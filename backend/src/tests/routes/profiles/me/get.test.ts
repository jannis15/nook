import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { Profile } from '../../../../lib/supabase.js';
import {
  createProfilesTestApp,
  testRequireAuth,
  testRequestId,
  testSupabase,
  testUserId,
} from './test-utils.js';

const getOwnProfile = vi.fn();

vi.mock('../../../../middleware/auth.js', () => ({
  requireAuth: testRequireAuth,
}));

vi.mock('../../../../domain/profile-service.js', () => ({
  getOwnProfile,
}));

const { registerGetMeRoute } = await import(
  '../../../../routes/profiles/me/get.js'
);

describe('GET /profiles/me', () => {
  beforeEach(() => {
    getOwnProfile.mockReset();
  });

  it('returns the app profile', async () => {
    const profile: Profile = {
      id: testUserId,
      email: 'test@nook.local',
      username: 'test_user',
      created_at: '2026-07-28T00:00:00.000Z',
      updated_at: '2026-07-28T00:00:00.000Z',
    };

    getOwnProfile.mockResolvedValue({ ok: true, profile });

    const response =
      await createProfilesTestApp(registerGetMeRoute).request('/profiles/me');

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({ profile });
    expect(getOwnProfile).toHaveBeenCalledWith(
      testSupabase,
      testUserId,
      testRequestId,
    );
  });

  it('returns a typed error when the profile is missing', async () => {
    getOwnProfile.mockResolvedValue({
      ok: false,
      error: {
        code: 'profile_not_found',
        message: 'Profile not found',
      },
    });

    const response =
      await createProfilesTestApp(registerGetMeRoute).request('/profiles/me');

    expect(response.status).toBe(404);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: 'profile_not_found',
        message: 'Profile not found',
      },
    });
  });
});
