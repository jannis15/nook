import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../app-types.js';
import { registerProfile } from '../../domain/profile-registration-service.js';
import { apiError, errorResponseSchema } from '../../lib/errors.js';
import { openApiTags } from '../../lib/openapi-tags.js';
import { createSupabaseAdminClient } from '../../lib/supabase.js';

const profileRegistrationSchema = z
  .object({
    email: z.string().trim().email(),
    password: z
      .string()
      .min(12)
      .regex(/[a-z]/)
      .regex(/[A-Z]/)
      .regex(/\d/)
      .regex(/[!@#$%^&*()_+\-=\[\]{}|;:,.?]/),
    username: z
      .string()
      .trim()
      .regex(/^[a-z0-9_]{3,30}$/),
  })
  .strict();

const postProfileRoute = createRoute({
  method: 'post',
  path: '/profiles',
  tags: [openApiTags.profiles],
  request: {
    body: {
      required: true,
      content: {
        'application/json': { schema: profileRegistrationSchema },
      },
    },
  },
  responses: {
    201: {
      description: 'Profile created; email verification sent',
      content: {
        'application/json': {
          schema: z.object({ message: z.string() }),
        },
      },
    },
    400: {
      description: 'Invalid request',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
    409: {
      description: 'Username or email is already registered',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
    500: {
      description: 'Profile creation failed',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
  },
});

export function registerPostProfileRoute(app: App) {
  app.openapi(postProfileRoute, async (c) => {
    const body = c.req.valid('json');
    const result = await registerProfile(
      createSupabaseAdminClient(),
      {
        email: body.email,
        password: body.password,
        username: body.username,
      },
      c.get('requestId'),
    );

    if (!result.ok) {
      return c.json(
        apiError(result.error.code, result.error.message),
        result.error.code === 'conflict' ? 409 : 500,
      );
    }

    return c.json({ message: 'Verification email sent' }, 201);
  });
}
