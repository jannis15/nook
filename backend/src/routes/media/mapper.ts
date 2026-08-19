import type { MediaEntity } from '../../domain/media.js';
import type { Supabase } from '../../lib/supabase.js';
import type { MediaDetailResponse, MediaResponse } from './types.js';

const mediaBucket = 'media';
const mediaUrlExpiresInSeconds = 60 * 60;

type MediaResponseOptions = {
  includeMediaUrl?: boolean;
};

export function toMediaResponse(
  supabase: Supabase,
  media: MediaEntity,
  options: { includeMediaUrl: true },
): Promise<MediaDetailResponse>;
export function toMediaResponse(
  supabase: Supabase,
  media: MediaEntity,
  options?: MediaResponseOptions,
): Promise<MediaResponse>;
export async function toMediaResponse(
  supabase: Supabase,
  media: MediaEntity,
  options: MediaResponseOptions = {},
): Promise<MediaResponse | MediaDetailResponse> {
  const mediaUrl = options.includeMediaUrl
    ? await createSignedStorageUrl(supabase, media.storageKey)
    : null;
  const base = {
    id: media.id,
    ...(options.includeMediaUrl ? { media_url: mediaUrl } : {}),
    original_filename: media.originalFilename,
    title: media.title,
    description: media.description,
    media_type: media.mediaType,
    mime_type: media.mimeType,
    file_size: media.fileSize,
    content_hash: media.contentHash,
    width: media.width,
    height: media.height,
    captured_at: media.capturedAt,
    status: media.status,
    created_at: media.createdAt,
    updated_at: media.updatedAt,
  };

  if (media.mediaType === 'video') {
    return {
      ...base,
      media_type: 'video',
      duration_seconds: media.durationSeconds,
    };
  }

  return {
    ...base,
    media_type: 'image',
  };
}

async function createSignedStorageUrl(
  supabase: Supabase,
  storageKey: string | null,
): Promise<string | null> {
  if (!storageKey) {
    return null;
  }

  const { data, error } = await supabase.storage
    .from(mediaBucket)
    .createSignedUrl(storageKey, mediaUrlExpiresInSeconds);

  if (error) {
    return null;
  }

  return data.signedUrl;
}
