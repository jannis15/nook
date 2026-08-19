import { beforeEach, describe, expect, it, vi } from 'vitest';
import {
  createMediaTestApp,
  testRequireAuth,
  testRequestId,
  testSupabase,
  testUserId,
} from '../test-utils.js';

const deleteOwnMediaById = vi.fn();

vi.mock('../../../../middleware/auth.js', () => ({
  requireAuth: testRequireAuth,
}));

vi.mock('../../../../domain/media-service.js', () => ({
  deleteOwnMediaById,
}));

const { registerDeleteMediaByIdRoute } = await import(
  '../../../../routes/media/{id}/delete.js'
);

const mediaId = '10000000-0000-4000-8000-000000000001';

describe('DELETE /media/:id', () => {
  beforeEach(() => {
    deleteOwnMediaById.mockReset();
  });

  it('deletes media', async () => {
    deleteOwnMediaById.mockResolvedValue({ ok: true });

    const response = await createMediaTestApp(
      registerDeleteMediaByIdRoute,
    ).request(`/media/${mediaId}`, { method: 'DELETE' });

    expect(response.status).toBe(204);
    expect(await response.text()).toBe('');
    expect(deleteOwnMediaById).toHaveBeenCalledWith(
      testSupabase,
      testUserId,
      mediaId,
      testRequestId,
    );
  });

  it('returns 404 when media is missing', async () => {
    deleteOwnMediaById.mockResolvedValue({
      ok: false,
      error: {
        code: 'not_found',
        message: 'Media not found',
      },
    });

    const response = await createMediaTestApp(
      registerDeleteMediaByIdRoute,
    ).request(`/media/${mediaId}`, { method: 'DELETE' });

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
      registerDeleteMediaByIdRoute,
    ).request('/media/not-a-uuid', { method: 'DELETE' });

    expect(response.status).toBe(400);
    expect(deleteOwnMediaById).not.toHaveBeenCalled();
  });
});
