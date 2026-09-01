import { createRoute } from '@hono/zod-openapi';
import type { App } from '../../../../app-types.js';
import { errorResponseSchema } from '../../../../lib/errors.js';
import { openApiTags } from '../../../../lib/openapi-tags.js';
import { requireSession } from '../../../../middleware/auth.js';
import { emailVerificationStatusResponseSchema } from '../types.js';

const getEmailVerificationStatusRoute = createRoute({
  method: 'get',
  path: '/profiles/me/email-verification',
  tags: [openApiTags.profiles],
  middleware: [requireSession] as const,
  security: [{ bearerAuth: [] }],
  responses: {
    200: {
      description: 'Authenticated user email verification status',
      content: {
        'application/json': {
          schema: emailVerificationStatusResponseSchema,
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
    500: {
      description: 'Bearer token verification failed',
      content: {
        'application/json': {
          schema: errorResponseSchema,
        },
      },
    },
  },
});

export function registerGetEmailVerificationStatusRoute(app: App) {
  app.openapi(getEmailVerificationStatusRoute, (c) =>
    c.json({ is_email_verified: c.get('isEmailVerified') }, 200),
  );
}
