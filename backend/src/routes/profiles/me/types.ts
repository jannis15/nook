import { z } from '@hono/zod-openapi';

export const profileSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email().nullable(),
  display_name: z.string().nullable(),
  created_at: z.string(),
  updated_at: z.string(),
});

export const profileResponseSchema = z.object({
  profile: profileSchema,
});
