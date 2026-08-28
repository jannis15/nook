import { execFile } from 'node:child_process';
import { createHash } from 'node:crypto';
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { extname, join } from 'node:path';
import { promisify } from 'node:util';
import { encode } from 'blurhash';
import sharp from 'sharp';
import { logger } from './lib/logger.js';
import {
  createSupabaseAdminClient,
  type MediaRow,
  type Supabase,
} from './lib/supabase.js';

const execFileAsync = promisify(execFile);
const mediaBucket = 'media';
const claimLimit = 2;
const leaseSeconds = 15 * 60;
const idleDelayMs = 1_000;
const previewMaxDimension = 768;

type ProcessedPreview = {
  blurHash: string;
  bytes: Buffer;
  durationSeconds: number | null;
  height: number;
  previewTimestampSeconds: number | null;
  width: number;
};

let isStopping = false;

process.on('SIGINT', () => {
  isStopping = true;
});
process.on('SIGTERM', () => {
  isStopping = true;
});

async function main(): Promise<void> {
  const supabase = createSupabaseAdminClient();
  const runOnce = process.argv.includes('--once');

  logger.info({ runOnce }, 'Media worker started');
  do {
    const count = await processNextJobs(supabase);
    if (runOnce || isStopping) break;
    if (count === 0) await delay(idleDelayMs);
  } while (!isStopping);
  logger.info('Media worker stopped');
}

async function processNextJobs(supabase: Supabase): Promise<number> {
  const { data, error } = await supabase.rpc('claim_media_processing_jobs', {
    p_limit: claimLimit,
    p_lease_seconds: leaseSeconds,
  });
  if (error) throw error;

  for (const media of data) {
    await processMedia(supabase, media);
  }
  return data.length;
}

async function processMedia(
  supabase: Supabase,
  media: MediaRow,
): Promise<void> {
  const leaseToken = media.processing_lease_token;
  if (!leaseToken) {
    logger.error(
      { mediaId: media.id },
      'Claimed media is missing a processing lease',
    );
    return;
  }

  try {
    const original = await downloadOriginal(supabase, media.storage_key);
    const preview = await createPreview(media, original);
    const previewStorageKey = `${media.owner_id}/media/${media.id}/preview.webp`;
    const { error: uploadError } = await supabase.storage
      .from(mediaBucket)
      .upload(previewStorageKey, preview.bytes, {
        contentType: 'image/webp',
        upsert: true,
      });
    if (uploadError) throw uploadError;

    const { data, error } = await supabase.rpc(
      'finalize_media_processing_job',
      {
        p_blur_hash: preview.blurHash,
        p_content_hash: createHash('sha256').update(original).digest('hex'),
        p_height: preview.height,
        p_lease_token: leaseToken,
        p_media_id: media.id,
        p_preview_storage_key: previewStorageKey,
        p_status: 'ready',
        p_width: preview.width,
        ...(preview.durationSeconds == null
          ? {}
          : { p_duration_seconds: preview.durationSeconds }),
        ...(preview.previewTimestampSeconds == null
          ? {}
          : { p_preview_timestamp_seconds: preview.previewTimestampSeconds }),
      },
    );
    if (error) throw error;
    if (data.length === 0) {
      logger.warn(
        { mediaId: media.id },
        'Media processing job was no longer active before finalization',
      );
      await removePreview(supabase, previewStorageKey, media.id);
      return;
    }
    logger.info({ mediaId: media.id }, 'Media processing completed');
  } catch (error) {
    logger.error({ error, mediaId: media.id }, 'Media processing failed');
    await finalizeFailure(supabase, media.id, leaseToken, error);
  }
}

async function removePreview(
  supabase: Supabase,
  previewStorageKey: string,
  mediaId: string,
): Promise<void> {
  const { error } = await supabase.storage
    .from(mediaBucket)
    .remove([previewStorageKey]);
  if (error) {
    logger.error(
      { error, mediaId, previewStorageKey },
      'Could not remove unfinalized media preview',
    );
  }
}

async function downloadOriginal(
  supabase: Supabase,
  storageKey: string,
): Promise<Buffer> {
  const { data, error } = await supabase.storage
    .from(mediaBucket)
    .download(storageKey);
  if (error) throw error;
  return Buffer.from(await data.arrayBuffer());
}

async function createPreview(
  media: MediaRow,
  original: Buffer,
): Promise<ProcessedPreview> {
  if (media.media_type === 'image') {
    return createImagePreview(original, null, null);
  }
  return createVideoPreview(media.storage_key, original);
}

async function createVideoPreview(
  storageKey: string,
  original: Buffer,
): Promise<ProcessedPreview> {
  const directory = await mkdtemp(join(tmpdir(), 'nook-media-'));
  const sourcePath = join(
    directory,
    `original${extname(storageKey) || '.video'}`,
  );
  const framePath = join(directory, 'preview.png');

  try {
    await writeFile(sourcePath, original);
    const durationSeconds = await getVideoDuration(sourcePath);
    const previewTimestampSeconds = Math.min(durationSeconds * 0.1, 5);
    await execFileAsync(process.env.FFMPEG_PATH ?? 'ffmpeg', [
      '-y',
      '-ss',
      previewTimestampSeconds.toFixed(3),
      '-i',
      sourcePath,
      '-frames:v',
      '1',
      framePath,
    ]);
    return createImagePreview(
      await readFile(framePath),
      durationSeconds,
      previewTimestampSeconds,
    );
  } finally {
    await rm(directory, { force: true, recursive: true });
  }
}

async function createImagePreview(
  source: Buffer,
  durationSeconds: number | null,
  previewTimestampSeconds: number | null,
): Promise<ProcessedPreview> {
  const metadata = await sharp(source).metadata();
  if (!metadata.width || !metadata.height) {
    throw new Error('Media dimensions could not be determined');
  }
  const bytes = await sharp(source)
    .rotate()
    .resize({
      width: previewMaxDimension,
      height: previewMaxDimension,
      fit: 'inside',
      withoutEnlargement: true,
    })
    .webp({ quality: 82 })
    .toBuffer();
  const { data, info } = await sharp(bytes)
    .resize({ width: 64, height: 64, fit: 'inside', withoutEnlargement: true })
    .ensureAlpha()
    .raw()
    .toBuffer({ resolveWithObject: true });

  return {
    blurHash: encode(
      new Uint8ClampedArray(data.buffer, data.byteOffset, data.byteLength),
      info.width,
      info.height,
      4,
      3,
    ),
    bytes,
    durationSeconds,
    height: metadata.height,
    previewTimestampSeconds,
    width: metadata.width,
  };
}

async function getVideoDuration(sourcePath: string): Promise<number> {
  const { stdout } = await execFileAsync(
    process.env.FFPROBE_PATH ?? 'ffprobe',
    [
      '-v',
      'error',
      '-show_entries',
      'format=duration',
      '-of',
      'json',
      sourcePath,
    ],
  );
  const value: unknown = JSON.parse(stdout);
  if (
    typeof value !== 'object' ||
    value === null ||
    !('format' in value) ||
    typeof value.format !== 'object' ||
    value.format === null ||
    !('duration' in value.format) ||
    typeof value.format.duration !== 'string'
  ) {
    throw new Error('Video duration could not be determined');
  }
  const durationSeconds = Number.parseFloat(value.format.duration);
  if (!Number.isFinite(durationSeconds) || durationSeconds < 0) {
    throw new Error('Video duration is invalid');
  }
  return durationSeconds;
}

async function finalizeFailure(
  supabase: Supabase,
  mediaId: string,
  leaseToken: string,
  error: unknown,
): Promise<void> {
  const message =
    error instanceof Error ? error.message : 'Media processing failed';
  const { error: finalizeError } = await supabase.rpc(
    'finalize_media_processing_job',
    {
      p_lease_token: leaseToken,
      p_media_id: mediaId,
      p_processing_error: message,
      p_status: 'failed',
    },
  );
  if (finalizeError) {
    logger.error(
      { error: finalizeError, mediaId },
      'Could not record media processing failure',
    );
  }
}

function delay(milliseconds: number): Promise<void> {
  return new Promise((resolve) => {
    setTimeout(resolve, milliseconds);
  });
}

await main();
