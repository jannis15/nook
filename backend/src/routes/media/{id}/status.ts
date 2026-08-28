import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../../app-types.js';
import { waitForOwnMediaStatusById } from '../../../domain/media-service.js';
import { apiError, errorResponseSchema } from '../../../lib/errors.js';
import { openApiTags } from '../../../lib/openapi-tags.js';
import { requireAuth } from '../../../middleware/auth.js';
import { toMediaResponse } from '../mapper.js';
import { mediaStatusResponseSchema } from '../types.js';

const paramsSchema = z.object({
  id: z
    .string()
    .uuid()
    .openapi({ param: { name: 'id', in: 'path' } }),
});

const querySchema = z.object({
  wait: z.coerce.number().int().min(0).max(25).default(25),
});

const statusByErrorCode = {
  not_found: 404,
  internal_server_error: 500,
} as const;

const getMediaStatusRoute = createRoute({
  method: 'get',
  path: '/media/{id}/status',
  tags: [openApiTags.media],
  middleware: [requireAuth] as const,
  security: [{ bearerAuth: [] }],
  request: { params: paramsSchema, query: querySchema },
  responses: {
    200: {
      description:
        'Current media processing status, waiting up to the requested duration',
      content: { 'application/json': { schema: mediaStatusResponseSchema } },
    },
    400: {
      description: 'Invalid request',
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
    500: {
      description: 'Media status could not be loaded',
      content: { 'application/json': { schema: errorResponseSchema } },
    },
  },
});

export function registerGetMediaStatusRoute(app: App) {
  app.openapi(getMediaStatusRoute, async (c) => {
    const result = await waitForOwnMediaStatusById(
      c.get('supabase'),
      c.get('userId'),
      c.req.valid('param').id,
      c.req.valid('query').wait,
      c.get('requestId'),
    );
    if (!result.ok) {
      return c.json(
        apiError(result.error.code, result.error.message),
        statusByErrorCode[result.error.code],
      );
    }

    return c.json(
      {
        media: await toMediaResponse(c.get('supabase'), result.media),
      },
      200,
    );
  });
}
