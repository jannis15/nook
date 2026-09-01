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

type UpdateUsernameResult =
  | { ok: true; profile: Profile }
  | { ok: false; error: { code: 'conflict' | 'internal_server_error'; message: string } };

/** Updates the authenticated user's username. */
export async function updateOwnUsername(
  supabase: Supabase,
  userId: string,
  username: string,
  requestId: string,
): Promise<UpdateUsernameResult> {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .update({ username, is_username_configured: true })
      .eq('id', userId)
      .select()
      .single();

    if (error) {
      if (error.code === '23505') {
        return { ok: false, error: { code: 'conflict', message: 'Username is already taken' } };
      }

      throw error;
    }

    logger.info({ requestId, userId }, 'Profile username updated');
    return { ok: true, profile: data };
  } catch (error) {
    logger.error({ error, requestId, userId }, 'Profile username update failed');
    return {
      ok: false,
      error: { code: 'internal_server_error', message: 'Username could not be updated' },
    };
  }
}
