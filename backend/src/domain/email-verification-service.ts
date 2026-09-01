import { logger } from '../lib/logger.js';
import type { Supabase } from '../lib/supabase.js';

export async function resendEmailVerification(
  supabase: Supabase,
  email: string,
  requestId: string,
) {
  const { error } = await supabase.auth.resend({ type: 'signup', email });

  if (error) {
    logger.warn({ error, requestId }, 'Email verification resend failed');
    return;
  }

  logger.info({ requestId }, 'Email verification resent');
}
