import { beforeEach, describe, expect, it, vi } from 'vitest';
import {
  createMediaTestApp,
  testRequireAuth,
  testRequestId,
  testSupabase,
  testUserId,
} from '../test-utils.js';

const completeOwnMediaUpload = vi.fn();
const triggerMediaWorker = vi.fn();

vi.mock('../../../../lib/logger.js', () => ({
  logger: { error: vi.fn() },
}));

vi.mock('../../../../middleware/auth.js', () => ({
  requireAuth: testRequireAuth,
}));
vi.mock('../../../../domain/media-upload-service.js', () => ({
  completeOwnMediaUpload,
}));
vi.mock('../../../../lib/media-worker-trigger.js', () => ({
  triggerMediaWorker,
}));

const { registerCompleteMediaUploadRoute } = await import(
  '../../../../routes/media/{id}/complete.js'
);

const mediaId = '10000000-0000-4000-8000-000000000001';

describe('POST /media/:id/complete', () => {
  beforeEach(() => {
    completeOwnMediaUpload.mockReset();
    triggerMediaWorker.mockReset();
  });

  it('passes the authenticated owner and media ID to completion', async () => {
    completeOwnMediaUpload.mockResolvedValue({
      ok: false,
      error: { code: 'not_found', message: 'Media not found' },
    });

    const response = await createMediaTestApp(
      registerCompleteMediaUploadRoute,
    ).request(`/media/${mediaId}/complete`, { method: 'POST' });

    expect(response.status).toBe(404);
    expect(completeOwnMediaUpload).toHaveBeenCalledWith(
      testSupabase,
      testUserId,
      mediaId,
      testRequestId,
    );
  });

  it('returns 400 for invalid IDs', async () => {
    const response = await createMediaTestApp(
      registerCompleteMediaUploadRoute,
    ).request('/media/not-a-uuid/complete', { method: 'POST' });

    expect(response.status).toBe(400);
    expect(completeOwnMediaUpload).not.toHaveBeenCalled();
  });
});
