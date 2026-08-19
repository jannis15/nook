import { beforeEach, describe, expect, it, vi } from 'vitest';
import {
  createMediaTestApp,
  testRequireAuth,
  testRequestId,
  testSupabase,
  testUserId,
} from './test-utils.js';

const initializeOwnMediaUpload = vi.fn();

vi.mock('../../../middleware/auth.js', () => ({
  requireAuth: testRequireAuth,
}));
vi.mock('../../../domain/media-upload-service.js', () => ({
  initializeOwnMediaUpload,
}));

const { registerPostMediaRoute } = await import(
  '../../../routes/media/post.js'
);

const mediaId = '10000000-0000-4000-8000-000000000001';

describe('POST /media/uploads', () => {
  beforeEach(() => initializeOwnMediaUpload.mockReset());

  it('initializes an upload from media metadata', async () => {
    initializeOwnMediaUpload.mockResolvedValue({
      ok: true,
      value: {
        media: { id: mediaId },
        signedUploadUrl: 'https://example.test/upload',
        uploadExpiresAt: '2026-08-09T02:00:00.000Z',
      },
    });

    const response = await createMediaTestApp(registerPostMediaRoute).request(
      '/media/uploads',
      {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({
          filename: 'photo.jpg',
          mime_type: 'image/jpeg',
          file_size: 5,
        }),
      },
    );

    expect(response.status).toBe(201);
    await expect(response.json()).resolves.toEqual({
      media: { id: mediaId, status: 'pending' },
      signed_upload_url: 'https://example.test/upload',
      upload_expires_at: '2026-08-09T02:00:00.000Z',
    });
    expect(initializeOwnMediaUpload).toHaveBeenCalledWith(
      testSupabase,
      testUserId,
      { filename: 'photo.jpg', mimeType: 'image/jpeg', fileSize: 5 },
      testRequestId,
    );
  });

  it('returns 400 for an invalid request body', async () => {
    const response = await createMediaTestApp(registerPostMediaRoute).request(
      '/media/uploads',
      {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ filename: 'photo.jpg' }),
      },
    );

    expect(response.status).toBe(400);
    expect(initializeOwnMediaUpload).not.toHaveBeenCalled();
  });

  it('returns typed validation errors', async () => {
    initializeOwnMediaUpload.mockResolvedValue({
      ok: false,
      error: {
        code: 'validation_error',
        message: 'Only supported images and videos can be uploaded',
      },
    });

    const response = await createMediaTestApp(registerPostMediaRoute).request(
      '/media/uploads',
      {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({
          filename: 'notes.txt',
          mime_type: 'text/plain',
          file_size: 5,
        }),
      },
    );

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: 'validation_error',
        message: 'Only supported images and videos can be uploaded',
      },
    });
  });
});
