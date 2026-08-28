import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { ImageMediaEntity } from '../../../domain/media.js';
import {
  createMediaTestApp,
  testRequireAuth,
  testRequestId,
  testSupabase,
  testUserId,
} from './test-utils.js';

const listOwnMedia = vi.fn();

vi.mock('../../../middleware/auth.js', () => ({
  requireAuth: testRequireAuth,
}));

vi.mock('../../../domain/media-service.js', () => ({
  listOwnMedia,
}));

const { registerGetMediaListRoute } = await import(
  '../../../routes/media/get.js'
);

const imageMedia: ImageMediaEntity = {
  id: '10000000-0000-4000-8000-000000000001',
  ownerId: testUserId,
  storageKey:
    '00000000-0000-0000-0000-000000000001/media/10000000-0000-4000-8000-000000000001/original.jpg',
  originalFilename: 'photo.jpg',
  title: null,
  description: null,
  mediaType: 'image',
  mimeType: 'image/jpeg',
  fileSize: 12345,
  status: 'ready',
  processingError: null,
  metadata: {},
  createdAt: '2026-07-29T00:00:00.000Z',
  updatedAt: '2026-07-29T00:00:00.000Z',
};

describe('GET /media', () => {
  beforeEach(() => {
    listOwnMedia.mockReset();
  });

  it('returns the authenticated user media list', async () => {
    listOwnMedia.mockResolvedValue({
      ok: true,
      media: [imageMedia],
      nextCursor: { createdAt: imageMedia.createdAt, id: imageMedia.id },
    });

    const response = await createMediaTestApp(
      registerGetMediaListRoute,
    ).request('/media?media_type=image&limit=25');

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({
      media: [
        {
          id: imageMedia.id,
          original_filename: imageMedia.originalFilename,
          title: imageMedia.title,
          description: imageMedia.description,
          media_type: 'image',
          mime_type: imageMedia.mimeType,
          file_size: imageMedia.fileSize,
          status: imageMedia.status,
          preview_url: null,
          created_at: imageMedia.createdAt,
          updated_at: imageMedia.updatedAt,
        },
      ],
      next_cursor: Buffer.from(
        JSON.stringify({ createdAt: imageMedia.createdAt, id: imageMedia.id }),
      ).toString('base64url'),
    });
    expect(listOwnMedia).toHaveBeenCalledWith(
      testSupabase,
      testUserId,
      {
        mediaType: 'image',
        limit: 25,
      },
      testRequestId,
    );
  });

  it('defaults the limit', async () => {
    listOwnMedia.mockResolvedValue({ ok: true, media: [] });

    const response = await createMediaTestApp(
      registerGetMediaListRoute,
    ).request('/media');

    expect(response.status).toBe(200);
    expect(listOwnMedia).toHaveBeenCalledWith(
      testSupabase,
      testUserId,
      { limit: 50 },
      testRequestId,
    );
  });

  it('decodes and forwards the cursor', async () => {
    const cursor = Buffer.from(
      JSON.stringify({
        createdAt: imageMedia.createdAt,
        id: imageMedia.id,
      }),
    ).toString('base64url');
    listOwnMedia.mockResolvedValue({
      ok: true,
      media: [],
      nextCursor: null,
    });

    const response = await createMediaTestApp(
      registerGetMediaListRoute,
    ).request(`/media?cursor=${cursor}`);

    expect(response.status).toBe(200);
    expect(listOwnMedia).toHaveBeenCalledWith(
      testSupabase,
      testUserId,
      {
        cursor: { createdAt: imageMedia.createdAt, id: imageMedia.id },
        limit: 50,
      },
      testRequestId,
    );
  });

  it('returns 400 for invalid filters', async () => {
    const response = await createMediaTestApp(
      registerGetMediaListRoute,
    ).request('/media?media_type=document');

    expect(response.status).toBe(400);
    expect(listOwnMedia).not.toHaveBeenCalled();
  });

  it('returns 400 for an invalid cursor', async () => {
    const response = await createMediaTestApp(
      registerGetMediaListRoute,
    ).request('/media?cursor=invalid');

    expect(response.status).toBe(400);
    expect(listOwnMedia).not.toHaveBeenCalled();
  });
});
