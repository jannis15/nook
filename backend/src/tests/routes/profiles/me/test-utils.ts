import type { OpenAPIHono } from '@hono/zod-openapi';
import { createMiddleware } from 'hono/factory';
import type { Supabase } from '../../../../lib/supabase.js';
import { createOpenAPIApp } from '../../../../lib/openapi.js';
import type { AuthVariables } from '../../../../middleware/auth.js';
import type { RequestVariables } from '../../../../middleware/request-id.js';

export const testAccessToken = 'test-access-token';
export const testRequestId = 'request-1';
export const testSupabase = {} as Supabase;
export const testUserId = '00000000-0000-0000-0000-000000000001';

export const testRequireAuth = createMiddleware(async (c, next) => {
  c.set('accessToken', testAccessToken);
  c.set('isEmailVerified', true);
  c.set('requestId', testRequestId);
  c.set('supabase', testSupabase);
  c.set('userId', testUserId);
  await next();
});

export const testRequireSession = testRequireAuth;

export function createProfilesTestApp(
  registerRoute: (app: ProfilesTestApp) => void,
) {
  const app = createOpenAPIApp();

  app.use(async (c, next) => {
    c.set('requestId', testRequestId);
    await next();
  });

  registerRoute(app);

  return app;
}

type ProfilesTestApp = OpenAPIHono<{
  Variables: AuthVariables & RequestVariables;
}>;
