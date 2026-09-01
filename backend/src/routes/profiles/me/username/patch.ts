import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../../../app-types.js';
import { updateOwnUsername } from '../../../../domain/profile-service.js';
import { apiError, errorResponseSchema } from '../../../../lib/errors.js';
import { openApiTags } from '../../../../lib/openapi-tags.js';
import { requireAuth } from '../../../../middleware/auth.js';
import { profileResponseSchema } from '../types.js';

const updateUsernameSchema = z
  .object({
    username: z.string().trim().regex(/^[a-z0-9_]{3,30}$/),
  })
  .strict();

const patchUsernameRoute = createRoute({
  method: 'patch',
  path: '/profiles/me/username',
  tags: [openApiTags.profiles],
  middleware: [requireAuth] as const,
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      required: true,
      content: { 'application/json': { schema: updateUsernameSchema } },
    },
  },
  responses: {
    200: {
      description: 'Username updated',
      content: { 'application/json': { schema: profileResponseSchema } },
    },
    400: {
      description: 'Invalid username',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
    401: {
      description: 'Missing or invalid bearer token',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
    409: {
      description: 'Username is already registered',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
    500: {
      description: 'Username could not be updated',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
  },
});

/** Registers the authenticated username-completion route. */
export function registerPatchOwnUsernameRoute(app: App) {
  app.openapi(patchUsernameRoute, async (c) => {
    const body = c.req.valid('json');
    const result = await updateOwnUsername(c.get('supabase'), c.get('userId'), body.username, c.get('requestId'));

    if (!result.ok) {
      return c.json(
        apiError(result.error.code, result.error.message),
        result.error.code === 'conflict' ? 409 : 500,
      );
    }

    return c.json({ profile: result.profile }, 200);
  });
}
