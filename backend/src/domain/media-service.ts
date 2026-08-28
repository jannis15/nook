import {
  deleteMediaById,
  findMediaById,
  listMedia,
  type ListMediaFilters,
  type MediaCursor,
} from '../dao/media-dao.js';
import { logger } from '../lib/logger.js';
import type { Supabase } from '../lib/supabase.js';
import { toMediaEntity, type MediaEntity } from './media.js';

type MediaErrorCode = 'not_found' | 'internal_server_error';

type MediaListResult =
  | { ok: true; media: MediaEntity[]; nextCursor: MediaCursor | null }
  | { ok: false; error: { code: MediaErrorCode; message: string } };

type MediaDetailResult =
  | { ok: true; media: MediaEntity }
  | { ok: false; error: { code: MediaErrorCode; message: string } };

type MediaDeleteResult =
  | { ok: true }
  | { ok: false; error: { code: MediaErrorCode; message: string } };

const mediaBucket = 'media';
const mediaStatusPollIntervalMs = 1_000;

export async function listOwnMedia(
  supabase: Supabase,
  userId: string,
  filters: ListMediaFilters,
  requestId: string,
): Promise<MediaListResult> {
  try {
    const media = await listMedia(supabase, userId, filters);
    const page = media.slice(0, filters.limit);
    const lastMedia = page.at(-1);
    const nextCursor =
      media.length > filters.limit && lastMedia
        ? { createdAt: lastMedia.created_at, id: lastMedia.id }
        : null;

    logger.debug(
      { requestId, userId, count: page.length, filters },
      'Media list loaded',
    );
    return { ok: true, media: page.map(toMediaEntity), nextCursor };
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

/**
 * Waits for a processing item to reach a terminal state without exposing a
 * signed original URL to clients that only need processing status.
 */
export async function waitForOwnMediaStatusById(
  supabase: Supabase,
  userId: string,
  mediaId: string,
  waitSeconds: number,
  requestId: string,
): Promise<MediaDetailResult> {
  try {
    const deadline = Date.now() + waitSeconds * 1_000;

    while (true) {
      const media = await findMediaById(supabase, userId, mediaId);
      if (!media) {
        logger.debug({ requestId, userId, mediaId }, 'Media status not found');
        return {
          ok: false,
          error: { code: 'not_found', message: 'Media not found' },
        };
      }

      const entity = toMediaEntity(media);
      if (
        entity.status === 'ready' ||
        entity.status === 'failed' ||
        Date.now() >= deadline
      ) {
        logger.debug(
          { requestId, userId, mediaId, status: entity.status },
          'Media status loaded',
        );
        return { ok: true, media: entity };
      }

      await new Promise<void>((resolve) => {
        setTimeout(
          resolve,
          Math.min(mediaStatusPollIntervalMs, deadline - Date.now()),
        );
      });
    }
  } catch (error) {
    logger.debug(
      { error, requestId, userId, mediaId },
      'Media status load failed',
    );
    return {
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Media status could not be loaded',
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
