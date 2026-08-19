import { basename, dirname } from 'node:path';
import {
  createMedia,
  deleteMediaById,
  findMediaById,
  listExpiredPendingMedia,
  updateMedia,
} from '../dao/media-dao.js';
import { logger } from '../lib/logger.js';
import type { MediaInsert, Supabase } from '../lib/supabase.js';
import { toMediaEntity, type MediaEntity } from './media.js';

const mediaBucket = 'media';
const signedUploadLifetimeMs = 2 * 60 * 60 * 1000;
const maxImageBytes = 10 * 1024 * 1024;
const maxVideoBytes = 100 * 1024 * 1024;
const supportedImageTypes = new Set([
  'image/jpeg',
  'image/png',
  'image/webp',
  'image/gif',
]);
const supportedVideoTypes = new Set([
  'video/mp4',
  'video/webm',
  'video/quicktime',
  'video/x-m4v',
  'video/x-msvideo',
  'video/x-matroska',
]);

type MediaType = 'image' | 'video';
type UploadMediaErrorCode =
  | 'validation_error'
  | 'not_found'
  | 'conflict'
  | 'internal_server_error';
type UploadMediaResult<T> =
  | { ok: true; value: T }
  | { ok: false; error: { code: UploadMediaErrorCode; message: string } };

export type UploadMetadata = {
  filename: string;
  mimeType: string;
  fileSize: number;
};

export type InitializedMediaUpload = {
  media: MediaEntity;
  signedUploadUrl: string;
  uploadExpiresAt: string;
};

export async function initializeOwnMediaUpload(
  supabase: Supabase,
  userId: string,
  input: UploadMetadata,
  requestId: string,
): Promise<UploadMediaResult<InitializedMediaUpload>> {
  const mediaType = mediaTypeForMimeType(input.mimeType);
  const validationError = validateMetadata(input, mediaType);
  if (validationError || !mediaType) {
    return {
      ok: false,
      error: {
        code: 'validation_error',
        message:
          validationError ?? 'Only supported images and videos can be uploaded',
      },
    };
  }

  const mediaId = crypto.randomUUID();
  const storageKey = `${userId}/media/${mediaId}/original-${sanitizeFilename(input.filename)}`;
  const uploadExpiresAt = new Date(
    Date.now() + signedUploadLifetimeMs,
  ).toISOString();

  try {
    await cleanupExpiredOwnMediaUploads(supabase, userId, requestId);
    const media = await createMedia(supabase, {
      id: mediaId,
      owner_id: userId,
      storage_key: storageKey,
      original_filename: input.filename,
      media_type: mediaType,
      mime_type: input.mimeType,
      file_size: input.fileSize,
      status: 'pending',
      upload_expires_at: uploadExpiresAt,
    } satisfies MediaInsert);
    const { data, error } = await supabase.storage
      .from(mediaBucket)
      .createSignedUploadUrl(storageKey);

    if (error) {
      await updateMedia(supabase, userId, mediaId, {
        status: 'failed',
        processing_error: 'Could not create an upload URL',
      });
      throw error;
    }

    logger.debug({ requestId, userId, mediaId }, 'Media upload initialized');
    return {
      ok: true,
      value: {
        media: toMediaEntity(media),
        signedUploadUrl: data.signedUrl,
        uploadExpiresAt,
      },
    };
  } catch (error) {
    logger.debug(
      { error, requestId, userId, mediaId },
      'Media upload initialization failed',
    );
    return {
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Media upload could not be initialized',
      },
    };
  }
}

export async function completeOwnMediaUpload(
  supabase: Supabase,
  userId: string,
  mediaId: string,
  requestId: string,
): Promise<UploadMediaResult<MediaEntity>> {
  try {
    const media = await findMediaById(supabase, userId, mediaId);
    if (!media)
      return {
        ok: false,
        error: { code: 'not_found', message: 'Media not found' },
      };
    if (media.status === 'ready')
      return { ok: true, value: toMediaEntity(media) };
    if (media.status !== 'pending') {
      return {
        ok: false,
        error: {
          code: 'conflict',
          message: 'Media upload cannot be completed',
        },
      };
    }
    if (new Date(media.upload_expires_at).getTime() < Date.now()) {
      return failMediaUpload(
        supabase,
        userId,
        mediaId,
        requestId,
        'Upload URL has expired',
      );
    }

    const object = await findUploadedObject(supabase, media.storage_key);
    if (!object || object.size !== media.file_size) {
      return failMediaUpload(
        supabase,
        userId,
        mediaId,
        requestId,
        'Uploaded file is missing or has an unexpected size',
      );
    }

    const verifiedMedia = await updateMedia(supabase, userId, mediaId, {
      status: 'ready',
      processing_error: null,
    });
    logger.debug({ requestId, userId, mediaId }, 'Media upload completed');
    return { ok: true, value: toMediaEntity(verifiedMedia) };
  } catch (error) {
    logger.debug(
      { error, requestId, userId, mediaId },
      'Media upload completion failed',
    );
    return {
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Media upload could not be completed',
      },
    };
  }
}

async function findUploadedObject(
  supabase: Supabase,
  storageKey: string,
): Promise<{ size: number } | null> {
  const { data, error } = await supabase.storage
    .from(mediaBucket)
    .list(dirname(storageKey), {
      limit: 1,
      search: basename(storageKey),
    });
  if (error) throw error;
  const object = data.find((item) => item.name === basename(storageKey));
  const size = object?.metadata?.size;
  return typeof size === 'number' ? { size } : null;
}

async function failMediaUpload(
  supabase: Supabase,
  userId: string,
  mediaId: string,
  requestId: string,
  message: string,
): Promise<UploadMediaResult<MediaEntity>> {
  const media = await findMediaById(supabase, userId, mediaId);
  if (media) {
    const { error } = await supabase.storage
      .from(mediaBucket)
      .remove([media.storage_key]);
    if (error) throw error;
  }
  await updateMedia(supabase, userId, mediaId, {
    status: 'failed',
    processing_error: message,
  });
  logger.debug(
    { requestId, userId, mediaId, message },
    'Media upload verification failed',
  );
  return { ok: false, error: { code: 'validation_error', message } };
}

async function cleanupExpiredOwnMediaUploads(
  supabase: Supabase,
  userId: string,
  requestId: string,
): Promise<void> {
  const expiredMedia = await listExpiredPendingMedia(
    supabase,
    userId,
    new Date().toISOString(),
  );
  for (const media of expiredMedia) {
    const { error } = await supabase.storage
      .from(mediaBucket)
      .remove([media.storage_key]);
    if (error) {
      logger.debug(
        { error, requestId, userId, mediaId: media.id },
        'Expired media object cleanup failed',
      );
      continue;
    }
    await deleteMediaById(supabase, userId, media.id);
  }
}

function mediaTypeForMimeType(mimeType: string): MediaType | null {
  if (supportedImageTypes.has(mimeType)) return 'image';
  if (supportedVideoTypes.has(mimeType)) return 'video';
  return null;
}

function validateMetadata(
  input: UploadMetadata,
  mediaType: MediaType | null,
): string | null {
  if (!input.filename.trim()) return 'File name is required';
  if (!mediaType) return 'Only supported images and videos can be uploaded';
  if (!Number.isSafeInteger(input.fileSize) || input.fileSize <= 0)
    return 'File size must be a positive integer';
  const maxBytes = mediaType === 'video' ? maxVideoBytes : maxImageBytes;
  if (input.fileSize > maxBytes)
    return mediaType === 'video'
      ? 'Videos must be 100 MB or smaller'
      : 'Images must be 10 MB or smaller';
  return null;
}

function sanitizeFilename(filename: string): string {
  const sanitized = filename
    .trim()
    .replace(/[^a-zA-Z0-9._-]+/g, '-')
    .replace(/^-+|-+$/g, '');
  return sanitized || 'upload';
}
