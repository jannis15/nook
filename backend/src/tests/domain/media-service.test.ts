import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { MediaRow, Supabase } from '../../lib/supabase.js';

const deleteMediaById = vi.hoisted(() => vi.fn());
const findMediaById = vi.hoisted(() => vi.fn());
const listMedia = vi.hoisted(() => vi.fn());
const logger = vi.hoisted(() => ({
  debug: vi.fn(),
}));

vi.mock('../../dao/media-dao.js', () => ({
  deleteMediaById,
  findMediaById,
  listMedia,
}));

vi.mock('../../lib/logger.js', () => ({
  logger,
}));

const { deleteOwnMediaById, getOwnMediaById, listOwnMedia } = await import(
  '../../domain/media-service.js'
);

const supabase = {} as Supabase;
const requestId = 'request-1';
const userId = '00000000-0000-0000-0000-000000000001';
const mediaId = '10000000-0000-4000-8000-000000000001';

const imageRow: MediaRow = {
  id: mediaId,
  owner_id: userId,
  storage_key: `${userId}/media/${mediaId}/original.jpg`,
  original_filename: 'photo.jpg',
  title: null,
  description: null,
  media_type: 'image',
  mime_type: 'image/jpeg',
  file_size: 12345,
  content_hash: null,
  width: 1200,
  height: 800,
  duration_seconds: null,
  captured_at: '2026-07-29T00:00:00.000Z',
  status: 'ready',
  processing_error: null,
  metadata: {},
  created_at: '2026-07-29T00:00:00.000Z',
  updated_at: '2026-07-29T00:00:00.000Z',
};

describe('media service', () => {
  beforeEach(() => {
    deleteMediaById.mockReset();
    findMediaById.mockReset();
    listMedia.mockReset();
    logger.debug.mockReset();
  });

  it('lists own media as image/video entities', async () => {
    listMedia.mockResolvedValue([imageRow]);

    await expect(
      listOwnMedia(
        supabase,
        userId,
        { mediaType: 'image', status: 'ready', limit: 25 },
        requestId,
      ),
    ).resolves.toEqual({
      ok: true,
      media: [
        {
          id: imageRow.id,
          ownerId: imageRow.owner_id,
          storageKey: imageRow.storage_key,
          originalFilename: imageRow.original_filename,
          title: imageRow.title,
          description: imageRow.description,
          mediaType: 'image',
          mimeType: imageRow.mime_type,
          fileSize: imageRow.file_size,
          contentHash: imageRow.content_hash,
          width: imageRow.width,
          height: imageRow.height,
          capturedAt: imageRow.captured_at,
          status: 'ready',
          processingError: imageRow.processing_error,
          metadata: imageRow.metadata,
          createdAt: imageRow.created_at,
          updatedAt: imageRow.updated_at,
        },
      ],
      nextCursor: null,
    });
    expect(listMedia).toHaveBeenCalledWith(supabase, userId, {
      mediaType: 'image',
      status: 'ready',
      limit: 25,
    });
  });

  it('returns a cursor from the last item when another page exists', async () => {
    const laterImageRow = {
      ...imageRow,
      id: '20000000-0000-4000-8000-000000000002',
      created_at: '2026-07-30T00:00:00.000Z',
    };
    listMedia.mockResolvedValue([laterImageRow, imageRow]);

    await expect(
      listOwnMedia(supabase, userId, { limit: 1 }, requestId),
    ).resolves.toMatchObject({
      ok: true,
      media: [{ id: laterImageRow.id }],
      nextCursor: {
        createdAt: laterImageRow.created_at,
        id: laterImageRow.id,
      },
    });
  });

  it('returns media detail when it exists', async () => {
    findMediaById.mockResolvedValue(imageRow);

    const result = await getOwnMediaById(supabase, userId, mediaId, requestId);

    expect(result).toMatchObject({
      ok: true,
      media: {
        id: mediaId,
        mediaType: 'image',
      },
    });
    expect(findMediaById).toHaveBeenCalledWith(supabase, userId, mediaId);
  });

  it('maps missing media to not_found', async () => {
    findMediaById.mockResolvedValue(null);

    await expect(
      getOwnMediaById(supabase, userId, mediaId, requestId),
    ).resolves.toEqual({
      ok: false,
      error: {
        code: 'not_found',
        message: 'Media not found',
      },
    });
  });

  it('maps list failures to internal_server_error', async () => {
    listMedia.mockRejectedValue(new Error('database unavailable'));

    await expect(
      listOwnMedia(supabase, userId, { limit: 50 }, requestId),
    ).resolves.toEqual({
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Media could not be loaded',
      },
    });
  });

  it('deletes media storage objects and row', async () => {
    const remove = vi.fn().mockResolvedValue({ error: null });
    const supabaseWithStorage = createSupabaseWithStorage(remove);
    findMediaById.mockResolvedValue(imageRow);
    deleteMediaById.mockResolvedValue(undefined);

    await expect(
      deleteOwnMediaById(supabaseWithStorage, userId, mediaId, requestId),
    ).resolves.toEqual({ ok: true });

    expect(remove).toHaveBeenCalledWith([imageRow.storage_key]);
    expect(deleteMediaById).toHaveBeenCalledWith(
      supabaseWithStorage,
      userId,
      mediaId,
    );
  });

  it('maps missing media deletion to not_found', async () => {
    const remove = vi.fn();
    const supabaseWithStorage = createSupabaseWithStorage(remove);
    findMediaById.mockResolvedValue(null);

    await expect(
      deleteOwnMediaById(supabaseWithStorage, userId, mediaId, requestId),
    ).resolves.toEqual({
      ok: false,
      error: {
        code: 'not_found',
        message: 'Media not found',
      },
    });

    expect(remove).not.toHaveBeenCalled();
    expect(deleteMediaById).not.toHaveBeenCalled();
  });

  it('maps storage deletion failures to internal_server_error', async () => {
    const remove = vi
      .fn()
      .mockResolvedValue({ error: new Error('storage unavailable') });
    const supabaseWithStorage = createSupabaseWithStorage(remove);
    findMediaById.mockResolvedValue(imageRow);

    await expect(
      deleteOwnMediaById(supabaseWithStorage, userId, mediaId, requestId),
    ).resolves.toEqual({
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Media could not be deleted',
      },
    });

    expect(deleteMediaById).not.toHaveBeenCalled();
  });

  it('maps row deletion failures to internal_server_error', async () => {
    const remove = vi.fn().mockResolvedValue({ error: null });
    const supabaseWithStorage = createSupabaseWithStorage(remove);
    findMediaById.mockResolvedValue(imageRow);
    deleteMediaById.mockRejectedValue(new Error('database unavailable'));

    await expect(
      deleteOwnMediaById(supabaseWithStorage, userId, mediaId, requestId),
    ).resolves.toEqual({
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Media could not be deleted',
      },
    });
  });
});

function createSupabaseWithStorage(remove: ReturnType<typeof vi.fn>): Supabase {
  return {
    storage: {
      from: vi.fn(() => ({
        remove,
      })),
    },
  } as unknown as Supabase;
}
