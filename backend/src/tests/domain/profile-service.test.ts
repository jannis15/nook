import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { Profile, Supabase } from '../../lib/supabase.js';

const findProfileById = vi.hoisted(() => vi.fn());
const logger = vi.hoisted(() => ({
  debug: vi.fn(),
}));

vi.mock('../../dao/profile-dao.js', () => ({
  findProfileById,
}));

vi.mock('../../lib/logger.js', () => ({
  logger,
}));

const { getOwnProfile } = await import('../../domain/profile-service.js');

const supabase = {} as Supabase;
const requestId = 'request-1';
const userId = '00000000-0000-0000-0000-000000000001';
const profile: Profile = {
  id: userId,
  email: 'test@nook.local',
  username: 'test_user',
  created_at: '2026-07-28T00:00:00.000Z',
  updated_at: '2026-07-28T00:00:00.000Z',
};

describe('profile service', () => {
  beforeEach(() => {
    findProfileById.mockReset();
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
});
