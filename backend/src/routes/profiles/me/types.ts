import { z } from '@hono/zod-openapi';

export const profileSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  username: z.string(),
  created_at: z.string(),
  updated_at: z.string(),
});

export const profileResponseSchema = z.object({
  profile: profileSchema,
});

export const emailVerificationStatusResponseSchema = z.object({
  is_email_verified: z.boolean(),
});
