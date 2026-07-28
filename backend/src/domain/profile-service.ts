import {
  findProfileById,
  updateProfileDisplayName,
} from '../dao/profile-dao.js';
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

export async function updateOwnProfileDisplayName(
  supabase: Supabase,
  userId: string,
  displayName: string | null,
  requestId: string,
): Promise<ProfileResult> {
  try {
    const existingProfile = await findProfileById(supabase, userId);

    if (!existingProfile) {
      logger.debug({ requestId, userId }, 'Profile not found');
      return {
        ok: false,
        error: {
          code: 'profile_not_found',
          message: 'Profile not found',
        },
      };
    }

    const profile = await updateProfileDisplayName(
      supabase,
      userId,
      displayName,
    );

    logger.debug(
      { requestId, userId, displayNameSet: displayName !== null },
      'Profile display name updated',
    );
    return { ok: true, profile };
  } catch (error) {
    logger.debug(
      { error, requestId, userId },
      'Profile display name update failed',
    );
    return {
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Profile could not be updated',
      },
    };
  }
}
