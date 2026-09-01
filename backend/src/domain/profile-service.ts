import { findProfileById } from '../dao/profile-dao.js';
import { logger } from '../lib/logger.js';
import type { Profile, Supabase } from '../lib/supabase.js';

type ProfileErrorCode = 'profile_not_found' | 'internal_server_error';

type ProfileResult =
  | { ok: true; profile: Profile }
  | { ok: false; error: { code: ProfileErrorCode; message: string } };

export async function getOwnProfile(
  supabase: Supabase,
  userId: string,
  requestId: string,
): Promise<ProfileResult> {
  const profile = await findProfileById(supabase, userId);

  if (!profile) {
    logger.debug({ requestId, userId }, 'Profile not found');
    return {
      ok: false,
      error: {
        code: 'profile_not_found',
        message: 'Profile not found',
      },
    };
  }

  logger.debug({ requestId, userId }, 'Profile loaded');
  return { ok: true, profile };
}
