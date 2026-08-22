import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { MediaRow, Supabase } from '../../lib/supabase.js';

const createMedia = vi.hoisted(() => vi.fn());
const deleteMediaById = vi.hoisted(() => vi.fn());
const findMediaById = vi.hoisted(() => vi.fn());
const listExpiredPendingMedia = vi.hoisted(() => vi.fn());
const updateMedia = vi.hoisted(() => vi.fn());
const logger = vi.hoisted(() => ({ debug: vi.fn() }));

vi.mock('../../dao/media-dao.js', () => ({
  createMedia,
  deleteMediaById,
  findMediaById,
  listExpiredPendingMedia,
  updateMedia,
}));
vi.mock('../../lib/logger.js', () => ({ logger }));

const { completeOwnMediaUpload, initializeOwnMediaUpload } = await import(
  '../../domain/media-upload-service.js'
);

const requestId = 'request-1';
const userId = '00000000-0000-0000-0000-000000000001';
const mediaId = '10000000-0000-4000-8000-000000000001';
const pendingMedia: MediaRow = {
  id: mediaId,
  owner_id: userId,
  storage_key: `${userId}/media/${mediaId}/original-photo.jpg`,
  original_filename: 'photo.jpg',
  title: null,
  description: null,
  media_type: 'image',
  mime_type: 'image/jpeg',
  file_size: 5,
  status: 'pending',
  processing_error: null,
  metadata: {},
  created_at: '2026-08-09T00:00:00.000Z',
  upload_expires_at: '2099-08-09T02:00:00.000Z',
  updated_at: '2026-08-09T00:00:00.000Z',
};

describe('media upload service', () => {
  beforeEach(() => {
    createMedia.mockReset();
    deleteMediaById.mockReset();
    findMediaById.mockReset();
    listExpiredPendingMedia.mockReset();
    updateMedia.mockReset();
    logger.debug.mockReset();
    listExpiredPendingMedia.mockResolvedValue([]);
  });

  it('initializes a pending upload and returns a signed URL', async () => {
    const { supabase, createSignedUploadUrl } = createSupabase();
    createMedia.mockResolvedValue(pendingMedia);
    createSignedUploadUrl.mockResolvedValue({
      data: {
        signedUrl: 'https://example.test/upload',
        path: 'path',
        token: 'token',
      },
      error: null,
    });

    await expect(
      initializeOwnMediaUpload(
        supabase,
        userId,
        { filename: 'photo.jpg', mimeType: 'image/jpeg', fileSize: 5 },
        requestId,
      ),
    ).resolves.toMatchObject({
      ok: true,
      value: {
        signedUploadUrl: 'https://example.test/upload',
        media: { id: mediaId, status: 'pending' },
      },
    });
    expect(createMedia).toHaveBeenCalledWith(
      supabase,
      expect.objectContaining({
        owner_id: userId,
        original_filename: 'photo.jpg',
        status: 'pending',
      }),
    );
    expect(listExpiredPendingMedia).toHaveBeenCalledWith(
      supabase,
      userId,
      expect.any(String),
    );
  });

  it('rejects unsupported metadata before creating an upload', async () => {
    const { supabase, createSignedUploadUrl } = createSupabase();

    await expect(
      initializeOwnMediaUpload(
        supabase,
        userId,
        { filename: 'notes.txt', mimeType: 'text/plain', fileSize: 5 },
        requestId,
      ),
    ).resolves.toEqual({
      ok: false,
      error: {
        code: 'validation_error',
        message: 'Only supported images and videos can be uploaded',
      },
    });
    expect(createMedia).not.toHaveBeenCalled();
    expect(createSignedUploadUrl).not.toHaveBeenCalled();
  });

  it('marks an upload ready after Storage reports the expected object size', async () => {
    const { supabase, list } = createSupabase();
    findMediaById.mockResolvedValue(pendingMedia);
    list.mockResolvedValue({
      data: [{ name: 'original-photo.jpg', metadata: { size: 5 } }],
      error: null,
    });
    updateMedia.mockResolvedValue({ ...pendingMedia, status: 'ready' });

    await expect(
      completeOwnMediaUpload(supabase, userId, mediaId, requestId),
    ).resolves.toMatchObject({
      ok: true,
      value: { id: mediaId, status: 'ready' },
    });
    expect(updateMedia).toHaveBeenCalledWith(supabase, userId, mediaId, {
      status: 'ready',
      processing_error: null,
    });
  });
});

function createSupabase() {
  const createSignedUploadUrl = vi.fn();
  const list = vi.fn();
  const remove = vi.fn().mockResolvedValue({ error: null });
  const supabase = {
    storage: {
      from: vi.fn(() => ({ createSignedUploadUrl, list, remove })),
    },
  } as unknown as Supabase;
  return { supabase, createSignedUploadUrl, list };
}
