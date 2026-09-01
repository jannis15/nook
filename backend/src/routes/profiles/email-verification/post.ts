import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../../app-types.js';
import { resendEmailVerification } from '../../../domain/email-verification-service.js';
import { openApiTags } from '../../../lib/openapi-tags.js';
import { createSupabaseAdminClient } from '../../../lib/supabase.js';

const resendEmailVerificationRoute = createRoute({
  method: 'post',
  path: '/profiles/email-verification/resend',
  tags: [openApiTags.profiles],
  request: {
    body: {
      required: true,
      content: {
        'application/json': {
          schema: z.object({ email: z.string().trim().email() }).strict(),
        },
      },
    },
  },
  responses: {
    204: { description: 'Verification email resend requested' },
    400: { description: 'Invalid request' },
  },
});

export function registerPostEmailVerificationResendRoute(app: App) {
  app.openapi(resendEmailVerificationRoute, async (c) => {
    const { email } = c.req.valid('json');
    await resendEmailVerification(
      createSupabaseAdminClient(),
      email,
      c.get('requestId'),
    );
    return c.body(null, 204);
  });
}
