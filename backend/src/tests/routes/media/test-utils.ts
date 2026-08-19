import type { OpenAPIHono } from '@hono/zod-openapi';
import { createMiddleware } from 'hono/factory';
import type { Supabase } from '../../../lib/supabase.js';
import { createOpenAPIApp } from '../../../lib/openapi.js';
import type { AuthVariables } from '../../../middleware/auth.js';
import type { RequestVariables } from '../../../middleware/request-id.js';

export const testAccessToken = 'test-access-token';
export const testMediaUrl = 'https://example.test/signed-media';
export const testRequestId = 'request-1';
export const testSupabase = {
  storage: {
    from: () => ({
      createSignedUrl: (storageKey: string) =>
        Promise.resolve({
          data: {
            signedUrl: testMediaUrl,
          },
          error: null,
        }),
    }),
  },
} as unknown as Supabase;
export const testUserId = '00000000-0000-0000-0000-000000000001';

export const testRequireAuth = createMiddleware(async (c, next) => {
  c.set('accessToken', testAccessToken);
  c.set('requestId', testRequestId);
  c.set('supabase', testSupabase);
  c.set('userId', testUserId);
  await next();
});

export function createMediaTestApp(registerRoute: (app: MediaTestApp) => void) {
  const app = createOpenAPIApp();

  app.use(async (c, next) => {
    c.set('requestId', testRequestId);
    await next();
  });

  registerRoute(app);

  return app;
}

type MediaTestApp = OpenAPIHono<{
  Variables: AuthVariables & RequestVariables;
}>;
