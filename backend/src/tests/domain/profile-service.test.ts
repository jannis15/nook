import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { Profile, Supabase } from '../../lib/supabase.js';

const findProfileById = vi.hoisted(() => vi.fn());
const updateProfileDisplayName = vi.hoisted(() => vi.fn());
const logger = vi.hoisted(() => ({
  debug: vi.fn(),
}));

vi.mock('../../dao/profile-dao.js', () => ({
  findProfileById,
  updateProfileDisplayName,
}));

vi.mock('../../lib/logger.js', () => ({
  logger,
}));

const { getOwnProfile, updateOwnProfileDisplayName } = await import(
  '../../domain/profile-service.js'
);

const supabase = {} as Supabase;
const requestId = 'request-1';
const userId = '00000000-0000-0000-0000-000000000001';
const profile: Profile = {
  id: userId,
  display_name: 'Test User',
  created_at: '2026-07-28T00:00:00.000Z',
  updated_at: '2026-07-28T00:00:00.000Z',
};

describe('profile service', () => {
  beforeEach(() => {
    findProfileById.mockReset();
    updateProfileDisplayName.mockReset();
    logger.debug.mockReset();
  });

  describe('getOwnProfile', () => {
    it('returns the profile when it exists', async () => {
      findProfileById.mockResolvedValue(profile);

      await expect(getOwnProfile(supabase, userId, requestId)).resolves.toEqual(
        {
          ok: true,
          profile,
        },
      );
      expect(findProfileById).toHaveBeenCalledWith(supabase, userId);
    });

    it('maps a missing profile to profile_not_found', async () => {
      findProfileById.mockResolvedValue(null);

      await expect(getOwnProfile(supabase, userId, requestId)).resolves.toEqual(
        {
          ok: false,
          error: {
            code: 'profile_not_found',
            message: 'Profile not found',
          },
        },
      );
    });
  });

  describe('updateOwnProfileDisplayName', () => {
    it('returns profile_not_found when the profile is missing', async () => {
      findProfileById.mockResolvedValue(null);

      await expect(
        updateOwnProfileDisplayName(supabase, userId, 'Test User', requestId),
      ).resolves.toEqual({
        ok: false,
        error: {
          code: 'profile_not_found',
          message: 'Profile not found',
        },
      });
      expect(updateProfileDisplayName).not.toHaveBeenCalled();
    });

    it('returns the updated profile when the profile exists', async () => {
      findProfileById.mockResolvedValue(profile);
      updateProfileDisplayName.mockResolvedValue(profile);

      await expect(
        updateOwnProfileDisplayName(supabase, userId, 'Test User', requestId),
      ).resolves.toEqual({ ok: true, profile });
      expect(updateProfileDisplayName).toHaveBeenCalledWith(
        supabase,
        userId,
        'Test User',
      );
    });

    it('maps storage update failures to internal_server_error', async () => {
      findProfileById.mockResolvedValue(profile);
      updateProfileDisplayName.mockRejectedValue(
        new Error('database unavailable'),
      );

      await expect(
        updateOwnProfileDisplayName(supabase, userId, 'Test User', requestId),
      ).resolves.toEqual({
        ok: false,
        error: {
          code: 'internal_server_error',
          message: 'Profile could not be updated',
        },
      });
    });
  });
});
