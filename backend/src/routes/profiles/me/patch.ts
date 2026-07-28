import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../../app-types.js';
import { apiError, errorResponseSchema } from '../../../lib/errors.js';
import { updateOwnProfileDisplayName } from '../../../domain/profile-service.js';
import { requireAuth } from '../../../middleware/auth.js';
import { profileResponseSchema } from './types.js';

const profilePatchSchema = z
  .object({
    display_name: z.string().trim().min(1).max(80).nullable(),
  })
  .strict();

const profileUpdateStatusByErrorCode = {
  profile_not_found: 404,
  internal_server_error: 500,
} as const;

const patchMeRoute = createRoute({
  method: 'patch',
  path: '/profiles/me',
  tags: ['Profiles'],
  middleware: [requireAuth] as const,
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      required: true,
      content: {
        'application/json': {
          schema: profilePatchSchema,
        },
      },
    },
  },
  responses: {
    200: {
      description: 'Updated app profile',
      content: {
        'application/json': {
          schema: profileResponseSchema,
        },
      },
    },
    400: {
      description: 'Invalid request',
      content: {
        'application/json': {
          schema: errorResponseSchema,
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
    500: {
      description: 'Profile update failed',
      content: {
        'application/json': {
          schema: errorResponseSchema,
        },
      },
    },
  },
});

export function registerPatchMeRoute(app: App) {
  app.openapi(patchMeRoute, async (c) => {
    const body = c.req.valid('json');
    const result = await updateOwnProfileDisplayName(
      c.get('supabase'),
      c.get('userId'),
      body.display_name,
      c.get('requestId'),
    );

    if (!result.ok) {
      return c.json(
        apiError(result.error.code, result.error.message),
        profileUpdateStatusByErrorCode[result.error.code],
      );
    }

    return c.json({ profile: result.profile }, 200);
  });
}
