import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../app-types.js';
import { initializeOwnMediaUpload } from '../../domain/media-upload-service.js';
import { apiError, errorResponseSchema } from '../../lib/errors.js';
import { openApiTags } from '../../lib/openapi-tags.js';
import { requireAuth } from '../../middleware/auth.js';
import { toMediaResponse } from './mapper.js';
import { initializeMediaUploadResponseSchema } from './types.js';

const postMediaRoute = createRoute({
  method: 'post',
  path: '/media/uploads',
  tags: [openApiTags.media],
  middleware: [requireAuth] as const,
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      required: true,
      content: {
        'application/json': {
          schema: z.object({
            filename: z.string(),
            mime_type: z.string(),
            file_size: z.number().int(),
          }),
        },
      },
    },
  },
  responses: {
    201: {
      description: 'Initialized media upload',
      content: {
        'application/json': {
          schema: initializeMediaUploadResponseSchema,
        },
      },
    },
    400: {
      description: 'Invalid upload',
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
    500: {
      description: 'Upload failed',
      content: {
        'application/json': {
          schema: errorResponseSchema,
        },
      },
    },
  },
});

export function registerPostMediaRoute(app: App) {
  app.openapi(postMediaRoute, async (c) => {
    const body = c.req.valid('json');
    const result = await initializeOwnMediaUpload(
      c.get('supabase'),
      c.get('userId'),
      {
        filename: body.filename,
        mimeType: body.mime_type,
        fileSize: body.file_size,
      },
      c.get('requestId'),
    );

    if (!result.ok) {
      return c.json(
        apiError(result.error.code, result.error.message),
        result.error.code === 'validation_error' ? 400 : 500,
      );
    }

    return c.json(
      {
        media: {
          id: result.value.media.id,
          status: 'pending',
        },
        signed_upload_url: result.value.signedUploadUrl,
        upload_expires_at: result.value.uploadExpiresAt,
      },
      201,
    );
  });
}
