import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { Profile } from '../../../../lib/supabase.js';
import {
  createProfilesTestApp,
  testRequireAuth,
  testRequestId,
  testSupabase,
  testUserId,
} from './test-utils.js';

const updateOwnProfileDisplayName = vi.fn();

vi.mock('../../../../middleware/auth.js', () => ({
  requireAuth: testRequireAuth,
}));

vi.mock('../../../../domain/profile-service.js', () => ({
  updateOwnProfileDisplayName,
}));

const { registerPatchMeRoute } = await import(
  '../../../../routes/profiles/me/patch.js'
);

describe('PATCH /profiles/me', () => {
  beforeEach(() => {
    updateOwnProfileDisplayName.mockReset();
  });

  it('updates the display name with a trimmed value', async () => {
    const profile: Profile = {
      id: testUserId,
      display_name: 'Updated User',
      created_at: '2026-07-28T00:00:00.000Z',
      updated_at: '2026-07-28T00:01:00.000Z',
    };

    updateOwnProfileDisplayName.mockResolvedValue({ ok: true, profile });

    const response = await createProfilesTestApp(registerPatchMeRoute).request(
      '/profiles/me',
      {
        method: 'PATCH',
        headers: {
          'content-type': 'application/json',
        },
        body: JSON.stringify({ display_name: '  Updated User  ' }),
      },
    );

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({ profile });
    expect(updateOwnProfileDisplayName).toHaveBeenCalledWith(
      testSupabase,
      testUserId,
      'Updated User',
      testRequestId,
    );
  });

  it('returns a not found error when the profile is missing', async () => {
    updateOwnProfileDisplayName.mockResolvedValue({
      ok: false,
      error: {
        code: 'profile_not_found',
        message: 'Profile not found',
      },
    });

    const response = await createProfilesTestApp(registerPatchMeRoute).request(
      '/profiles/me',
      {
        method: 'PATCH',
        headers: {
          'content-type': 'application/json',
        },
        body: JSON.stringify({ display_name: 'Updated User' }),
      },
    );

    expect(response.status).toBe(404);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: 'profile_not_found',
        message: 'Profile not found',
      },
    });
  });

  it('returns an internal server error when storage update fails', async () => {
    updateOwnProfileDisplayName.mockResolvedValue({
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Profile could not be updated',
      },
    });

    const response = await createProfilesTestApp(registerPatchMeRoute).request(
      '/profiles/me',
      {
        method: 'PATCH',
        headers: {
          'content-type': 'application/json',
        },
        body: JSON.stringify({ display_name: 'Updated User' }),
      },
    );

    expect(response.status).toBe(500);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: 'internal_server_error',
        message: 'Profile could not be updated',
      },
    });
  });

  it.each([
    ['malformed JSON', '{'],
    ['missing body', undefined],
    ['missing display name', JSON.stringify({})],
    [
      'unknown fields',
      JSON.stringify({ display_name: 'Updated User', unknown: true }),
    ],
    ['invalid field type', JSON.stringify({ display_name: 42 })],
    ['empty display name', JSON.stringify({ display_name: '' })],
    ['whitespace-only display name', JSON.stringify({ display_name: '   ' })],
    ['too-long display name', JSON.stringify({ display_name: 'a'.repeat(81) })],
  ])('returns a validation error for %s', async (_name, body) => {
    const response = await createProfilesTestApp(registerPatchMeRoute).request(
      '/profiles/me',
      {
        method: 'PATCH',
        headers: {
          'content-type': 'application/json',
        },
        body,
      },
    );

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      error: {
        code: 'validation_error',
        message: 'Invalid request',
      },
    });
    expect(updateOwnProfileDisplayName).not.toHaveBeenCalled();
  });
});
