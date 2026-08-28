import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { VideoMediaEntity } from '../../../../domain/media.js';
import {
  createMediaTestApp,
  testMediaUrl,
  testRequireAuth,
  testRequestId,
  testSupabase,
  testUserId,
} from '../test-utils.js';

const getOwnMediaById = vi.fn();

vi.mock('../../../../middleware/auth.js', () => ({
  requireAuth: testRequireAuth,
}));

vi.mock('../../../../domain/media-service.js', () => ({
  getOwnMediaById,
}));

const { registerGetMediaByIdRoute } = await import(
  '../../../../routes/media/{id}/get.js'
);

const mediaId = '10000000-0000-4000-8000-000000000001';
const videoMedia: VideoMediaEntity = {
  id: mediaId,
  ownerId: testUserId,
  storageKey: `${testUserId}/media/${mediaId}/original.mp4`,
  originalFilename: 'clip.mp4',
  title: null,
  description: null,
  mediaType: 'video',
  mimeType: 'video/mp4',
  fileSize: 12345,
  status: 'ready',
  processingError: null,
  metadata: {},
  createdAt: '2026-07-29T00:00:00.000Z',
  updatedAt: '2026-07-29T00:00:00.000Z',
};

describe('GET /media/:id', () => {
  beforeEach(() => {
    getOwnMediaById.mockReset();
  });

  it('returns media detail', async () => {
    getOwnMediaById.mockResolvedValue({ ok: true, media: videoMedia });

    const response = await createMediaTestApp(
      registerGetMediaByIdRoute,
    ).request(`/media/${mediaId}`);

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({
      media: {
        id: videoMedia.id,
        media_url: testMediaUrl,
        original_filename: videoMedia.originalFilename,
        title: videoMedia.title,
        description: videoMedia.description,
        media_type: 'video',
        mime_type: videoMedia.mimeType,
        file_size: videoMedia.fileSize,
        status: videoMedia.status,
        preview_url: null,
        created_at: videoMedia.createdAt,
        updated_at: videoMedia.updatedAt,
      },
    });
    expect(getOwnMediaById).toHaveBeenCalledWith(
      testSupabase,
      testUserId,
      mediaId,
      testRequestId,
    );
  });

  it('returns 404 when media is missing', async () => {
    getOwnMediaById.mockResolvedValue({
      ok: false,
      error: {
        code: 'not_found',
        message: 'Media not found',
      },
    });

    const response = await createMediaTestApp(
      registerGetMediaByIdRoute,
    ).request(`/media/${mediaId}`);

    expect(response.status).toBe(404);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: 'not_found',
        message: 'Media not found',
      },
    });
  });

  it('returns 400 for invalid ids', async () => {
    const response = await createMediaTestApp(
      registerGetMediaByIdRoute,
    ).request('/media/not-a-uuid');

    expect(response.status).toBe(400);
    expect(getOwnMediaById).not.toHaveBeenCalled();
  });
});
