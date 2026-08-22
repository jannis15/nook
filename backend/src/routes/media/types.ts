import { z } from '@hono/zod-openapi';

const mediaStatusSchema = z.enum(['pending', 'processing', 'ready', 'failed']);

const baseMediaSchema = z.object({
  id: z.string().uuid(),
  original_filename: z.string(),
  title: z.string().nullable(),
  description: z.string().nullable(),
  mime_type: z.string(),
  file_size: z.number().int().nonnegative(),
  status: mediaStatusSchema,
  created_at: z.string(),
  updated_at: z.string(),
});

export const imageMediaSchema = baseMediaSchema.extend({
  media_type: z.literal('image'),
});

export const videoMediaSchema = baseMediaSchema.extend({
  media_type: z.literal('video'),
});

export const mediaSchema = z.discriminatedUnion('media_type', [
  imageMediaSchema,
  videoMediaSchema,
]);

export const mediaDetailSchema = z.discriminatedUnion('media_type', [
  imageMediaSchema.extend({ media_url: z.string().nullable() }),
  videoMediaSchema.extend({ media_url: z.string().nullable() }),
]);

export const mediaListResponseSchema = z.object({
  media: z.array(mediaSchema),
  next_cursor: z.string().nullable(),
});

export const mediaResponseSchema = z.object({
  media: mediaDetailSchema,
});

export const initializeMediaUploadResponseSchema = z.object({
  media: z.object({
    id: z.string().uuid(),
    status: z.literal('pending'),
  }),
  signed_upload_url: z.string().url(),
  upload_expires_at: z.string().datetime(),
});

export type MediaResponse = z.infer<typeof mediaSchema>;
export type MediaDetailResponse = z.infer<typeof mediaDetailSchema>;
