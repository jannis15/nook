import { createRoute } from '@hono/zod-openapi';
import type { App } from '../../../app-types.js';
import { apiError, errorResponseSchema } from '../../../lib/errors.js';
import { getOwnProfile } from '../../../domain/profile-service.js';
import { requireAuth } from '../../../middleware/auth.js';
import { profileResponseSchema } from './types.js';

const getMeRoute = createRoute({
  method: 'get',
  path: '/profiles/me',
  tags: ['Profiles'],
  middleware: [requireAuth] as const,
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Authenticated app profile',
      content: {
        'application/json': {
          schema: profileResponseSchema,
        },
      },
    },
    401: {
      description: 'Missing or invalid bearer token',
      content: {
        'application/json': {
          schema: errorResponseSchema,
        },
      },
    },
    404: {
      description: 'Profile not found',
      content: {
        'application/json': {
          schema: errorResponseSchema,
        },
      },
    },
  },
});

export function registerGetMeRoute(app: App) {
  app.openapi(getMeRoute, async (c) => {
    const result = await getOwnProfile(
      c.get('supabase'),
      c.get('userId'),
      c.get('requestId'),
    );

    if (!result.ok) {
      return c.json(apiError(result.error.code, result.error.message), 404);
    }

    return c.json({ profile: result.profile }, 200);
  });
}
