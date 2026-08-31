import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../../app-types.js';
import { completeOwnMediaUpload } from '../../../domain/media-upload-service.js';
import { apiError, errorResponseSchema } from '../../../lib/errors.js';
import { logger } from '../../../lib/logger.js';
import { triggerMediaWorker } from '../../../lib/media-worker-trigger.js';
import { openApiTags } from '../../../lib/openapi-tags.js';
import { requireAuth } from '../../../middleware/auth.js';
import { toMediaResponse } from '../mapper.js';
import { mediaResponseSchema } from '../types.js';

const paramsSchema = z.object({
  id: z
    .string()
    .uuid()
    .openapi({ param: { name: 'id', in: 'path' } }),
});

const statusByErrorCode = {
  validation_error: 400,
  not_found: 404,
  conflict: 409,
  internal_server_error: 500,
} as const;

const completeMediaUploadRoute = createRoute({
  method: 'post',
  path: '/media/{id}/complete',
  tags: [openApiTags.media],
  middleware: [requireAuth] as const,
  security: [{ bearerAuth: [] }],
  request: { params: paramsSchema },
  responses: {
    200: {
      description: 'Verified media',
      content: { 'application/json': { schema: mediaResponseSchema } },
    },
    400: {
      description: 'Invalid upload',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
    401: {
      description: 'Missing or invalid bearer token',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
    404: {
      description: 'Media not found',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
    409: {
      description: 'Upload already completed',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
    500: {
      description: 'Upload completion failed',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
  },
});

export function registerCompleteMediaUploadRoute(app: App) {
  app.openapi(completeMediaUploadRoute, async (c) => {
    const result = await completeOwnMediaUpload(
      c.get('supabase'),
      c.get('userId'),
      c.req.valid('param').id,
      c.get('requestId'),
    );
    if (!result.ok)
      return c.json(
        apiError(result.error.code, result.error.message),
        statusByErrorCode[result.error.code],
      );
    try {
      await triggerMediaWorker(result.value.id);
    } catch (error) {
      logger.error(
        { error, mediaId: result.value.id, requestId: c.get('requestId') },
        'Could not trigger media worker job',
      );
    }
    return c.json(
      {
        media: await toMediaResponse(c.get('supabase'), result.value, {
          includeMediaUrl: true,
        }),
      },
      200,
    );
  });
}
