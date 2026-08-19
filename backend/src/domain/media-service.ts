import {
  deleteMediaById,
  findMediaById,
  listMedia,
  type ListMediaFilters,
} from '../dao/media-dao.js';
import { logger } from '../lib/logger.js';
import type { Supabase } from '../lib/supabase.js';
import { toMediaEntity, type MediaEntity } from './media.js';

type MediaErrorCode = 'not_found' | 'internal_server_error';

type MediaListResult =
  | { ok: true; media: MediaEntity[] }
  | { ok: false; error: { code: MediaErrorCode; message: string } };

type MediaDetailResult =
  | { ok: true; media: MediaEntity }
  | { ok: false; error: { code: MediaErrorCode; message: string } };

type MediaDeleteResult =
  | { ok: true }
  | { ok: false; error: { code: MediaErrorCode; message: string } };

const mediaBucket = 'media';

export async function listOwnMedia(
  supabase: Supabase,
  userId: string,
  filters: ListMediaFilters,
  requestId: string,
): Promise<MediaListResult> {
  try {
    const media = await listMedia(supabase, userId, filters);

    logger.debug(
      { requestId, userId, count: media.length, filters },
      'Media list loaded',
    );
    return { ok: true, media: media.map(toMediaEntity) };
  } catch (error) {
    logger.debug({ error, requestId, userId }, 'Media list failed');
    return {
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Media could not be loaded',
      },
    };
  }
}

export async function getOwnMediaById(
  supabase: Supabase,
  userId: string,
  mediaId: string,
  requestId: string,
): Promise<MediaDetailResult> {
  try {
    const media = await findMediaById(supabase, userId, mediaId);

    if (!media || media.status !== 'ready') {
      logger.debug({ requestId, userId, mediaId }, 'Media not found');
      return {
        ok: false,
        error: {
          code: 'not_found',
          message: 'Media not found',
        },
      };
    }

    logger.debug({ requestId, userId, mediaId }, 'Media loaded');
    return { ok: true, media: toMediaEntity(media) };
  } catch (error) {
    logger.debug({ error, requestId, userId, mediaId }, 'Media load failed');
    return {
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Media could not be loaded',
      },
    };
  }
}

export async function deleteOwnMediaById(
  supabase: Supabase,
  userId: string,
  mediaId: string,
  requestId: string,
): Promise<MediaDeleteResult> {
  try {
    const media = await findMediaById(supabase, userId, mediaId);

    if (!media) {
      logger.debug({ requestId, userId, mediaId }, 'Media not found');
      return {
        ok: false,
        error: {
          code: 'not_found',
          message: 'Media not found',
        },
      };
    }

    const { error: storageError } = await supabase.storage
      .from(mediaBucket)
      .remove([media.storage_key]);

    if (storageError) {
      throw storageError;
    }

    await deleteMediaById(supabase, userId, mediaId);

    logger.debug({ requestId, userId, mediaId }, 'Media deleted');
    return { ok: true };
  } catch (error) {
    logger.debug(
      { error, requestId, userId, mediaId },
      'Media deletion failed',
    );
    return {
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Media could not be deleted',
      },
    };
  }
}
