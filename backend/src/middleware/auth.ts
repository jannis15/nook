import { createMiddleware } from 'hono/factory';
import type { Context } from 'hono';
import { apiError } from '../lib/errors.js';
import { logger } from '../lib/logger.js';
import type { RequestVariables } from './request-id.js';
import { createSupabaseAdminClient, type Supabase } from '../lib/supabase.js';

export type AuthVariables = {
  accessToken: string;
  isEmailVerified: boolean;
  supabase: Supabase;
  userId: string;
};

export const requireSession = createMiddleware<{
  Variables: AuthVariables & RequestVariables;
}>(async (c, next) => {
  const failureResponse = await authenticateSession(c);
  if (failureResponse) {
    return failureResponse;
  }

  await next();
});

export const requireAuth = createMiddleware<{
  Variables: AuthVariables & RequestVariables;
}>(async (c, next) => {
  const failureResponse = await authenticateSession(c);
  if (failureResponse) {
    return failureResponse;
  }

  if (!c.get('isEmailVerified')) {
    logger.debug(
      { path: new URL(c.req.url).pathname, requestId: c.get('requestId') },
      'Auth failed: email not verified',
    );
    return c.json(
      apiError('email_not_verified', 'Email verification is required'),
      403,
    );
  }

  await next();
});

async function authenticateSession(
  c: Context<{ Variables: AuthVariables & RequestVariables }>,
): Promise<Response | undefined> {
  const authorization = c.req.header('authorization');
  const bearerMatch = authorization?.match(/^Bearer[ \t]+(.+)$/i);
  const accessToken = bearerMatch?.[1]?.trim();
  const requestId = c.get('requestId');

  if (!accessToken) {
    logger.debug(
      { path: new URL(c.req.url).pathname, requestId },
      'Auth failed: missing bearer token',
    );
    return c.json(
      apiError('missing_bearer_token', 'Missing bearer token'),
      401,
    );
  }

  let supabase: Supabase;
  let userId: string;

  try {
    supabase = createSupabaseAdminClient();
    const { data, error } = await supabase.auth.getUser(accessToken);

    if (error || !data.user) {
      logger.debug(
        { path: new URL(c.req.url).pathname, requestId },
        'Auth failed: invalid bearer token',
      );
      return c.json(
        apiError('invalid_bearer_token', 'Invalid bearer token'),
        401,
      );
    }

    userId = data.user.id;
    c.set('isEmailVerified', data.user.email_confirmed_at !== null);
  } catch (error) {
    logger.error(
      { error, path: new URL(c.req.url).pathname, requestId },
      'Auth failed: bearer token verification unavailable',
    );
    return c.json(
      apiError('internal_server_error', 'Unable to verify bearer token'),
      500,
    );
  }

  c.set('accessToken', accessToken);
  c.set('supabase', supabase);
  c.set('userId', userId);

  logger.debug({ requestId, userId }, 'Auth succeeded');
}
