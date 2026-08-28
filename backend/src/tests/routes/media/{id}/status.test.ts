import { beforeEach, describe, expect, it, vi } from 'vitest';
import {
  createMediaTestApp,
  testRequireAuth,
  testRequestId,
  testSupabase,
  testUserId,
} from '../test-utils.js';

const waitForOwnMediaStatusById = vi.fn();

vi.mock('../../../../middleware/auth.js', () => ({
  requireAuth: testRequireAuth,
}));
vi.mock('../../../../domain/media-service.js', () => ({
  waitForOwnMediaStatusById,
}));

const { registerGetMediaStatusRoute } = await import(
  '../../../../routes/media/{id}/status.js'
);

const mediaId = '10000000-0000-4000-8000-000000000001';

describe('GET /media/:id/status', () => {
  beforeEach(() => waitForOwnMediaStatusById.mockReset());

  it('passes the authenticated owner, media ID, and wait duration to the status lookup', async () => {
    waitForOwnMediaStatusById.mockResolvedValue({
      ok: true,
      media: {
        id: mediaId,
        ownerId: testUserId,
        storageKey: `${testUserId}/media/${mediaId}/original.jpg`,
        originalFilename: 'photo.jpg',
        title: null,
        description: null,
        mediaType: 'image',
        mimeType: 'image/jpeg',
        fileSize: 12345,
        status: 'ready',
        processingError: null,
        metadata: {},
        previewStorageKey: `${testUserId}/media/${mediaId}/preview.webp`,
        createdAt: '2026-07-29T00:00:00.000Z',
        updatedAt: '2026-07-29T00:00:00.000Z',
      },
    });

    const response = await createMediaTestApp(
      registerGetMediaStatusRoute,
    ).request(`/media/${mediaId}/status?wait=25`);

    expect(response.status).toBe(200);
    expect(waitForOwnMediaStatusById).toHaveBeenCalledWith(
      testSupabase,
      testUserId,
      mediaId,
      25,
      testRequestId,
    );
    await expect(response.json()).resolves.toMatchObject({
      media: {
        id: mediaId,
        status: 'ready',
        preview_url: 'https://example.test/signed-media',
      },
    });
  });

  it('returns 404 when the media does not belong to the authenticated user', async () => {
    waitForOwnMediaStatusById.mockResolvedValue({
      ok: false,
      error: { code: 'not_found', message: 'Media not found' },
    });

    const response = await createMediaTestApp(
      registerGetMediaStatusRoute,
    ).request(`/media/${mediaId}/status`);

    expect(response.status).toBe(404);
  });

  it('rejects invalid IDs and wait durations before querying media', async () => {
    const app = createMediaTestApp(registerGetMediaStatusRoute);

    await expect(
      app.request('/media/not-a-uuid/status'),
    ).resolves.toMatchObject({ status: 400 });
    await expect(
      app.request(`/media/${mediaId}/status?wait=26`),
    ).resolves.toMatchObject({ status: 400 });
    expect(waitForOwnMediaStatusById).not.toHaveBeenCalled();
  });
});
