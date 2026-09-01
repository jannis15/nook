import type { Supabase } from '../lib/supabase.js';
import { logger } from '../lib/logger.js';

type RegistrationErrorCode = 'conflict' | 'internal_server_error';

type RegistrationResult =
  | { ok: true }
  | {
      ok: false;
      error: { code: RegistrationErrorCode; message: string };
    };

type RegistrationInput = {
  email: string;
  password: string;
  username: string;
};

export async function registerProfile(
  supabase: Supabase,
  input: RegistrationInput,
  requestId: string,
): Promise<RegistrationResult> {
  try {
    const { data: existingProfile, error: profileError } = await supabase
      .from('profiles')
      .select('id')
      .eq('username', input.username)
      .maybeSingle();

    if (profileError) {
      throw profileError;
    }

    if (existingProfile) {
      return usernameConflict();
    }

    const { data, error } = await supabase.auth.admin.createUser({
      email: input.email,
      password: input.password,
      email_confirm: false,
      user_metadata: {
        username: input.username,
      },
    });

    if (error || !data.user) {
      if (error?.message.toLowerCase().includes('already been registered')) {
        return {
          ok: false,
          error: { code: 'conflict', message: 'Email is already registered' },
        };
      }

      throw error ?? new Error('Supabase did not create a user');
    }

    const { error: resendError } = await supabase.auth.resend({
      type: 'signup',
      email: input.email,
    });

    if (resendError) {
      await supabase.auth.admin.deleteUser(data.user.id);
      throw resendError;
    }

    logger.info({ requestId, userId: data.user.id }, 'Profile registered');
    return { ok: true };
  } catch (error) {
    if (isUsernameConflict(error)) {
      return usernameConflict();
    }

    logger.error({ error, requestId }, 'Profile registration failed');
    return {
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Profile could not be created',
      },
    };
  }
}

function usernameConflict(): RegistrationResult {
  return {
    ok: false,
    error: { code: 'conflict', message: 'Username is already taken' },
  };
}

function isUsernameConflict(error: unknown) {
  return (
    !!error &&
    typeof error === 'object' &&
    'message' in error &&
    typeof error.message === 'string' &&
    error.message.includes('profiles_username_key')
  );
}
