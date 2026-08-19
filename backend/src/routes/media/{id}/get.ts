import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../../app-types.js';
import { getOwnMediaById } from '../../../domain/media-service.js';
import { apiError, errorResponseSchema } from '../../../lib/errors.js';
import { openApiTags } from '../../../lib/openapi-tags.js';
import { requireAuth } from '../../../middleware/auth.js';
import { toMediaResponse } from '../mapper.js';
import { mediaResponseSchema } from '../types.js';

const mediaParamsSchema = z.object({
  id: z
    .string()
    .uuid()
    .openapi({
      param: {
        name: 'id',
        in: 'path',
      },
    }),
});

const getMediaByIdStatusByErrorCode = {
  not_found: 404,
  internal_server_error: 500,
} as const;

const getMediaByIdRoute = createRoute({
  method: 'get',
  path: '/media/{id}',
  tags: [openApiTags.media],
  middleware: [requireAuth] as const,
  security: [{ bearerAuth: [] }],
  request: {
    params: mediaParamsSchema,
  },
  responses: {
    200: {
      description: 'Authenticated user media item',
      content: {
        'application/json': {
          schema: mediaResponseSchema,
        },
      },
    },
    400: {
      description: 'Invalid request',
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
    404: {
      description: 'Media not found',
      content: {
        'application/json': {
          schema: errorResponseSchema,
        },
      },
    },
    500: {
      description: 'Media item load failed',
      content: {
        'application/json': {
          schema: errorResponseSchema,
        },
      },
    },
  },
});

export function registerGetMediaByIdRoute(app: App) {
  app.openapi(getMediaByIdRoute, async (c) => {
    const params = c.req.valid('param');
    const result = await getOwnMediaById(
      c.get('supabase'),
      c.get('userId'),
      params.id,
      c.get('requestId'),
    );

    if (!result.ok) {
      return c.json(
        apiError(result.error.code, result.error.message),
        getMediaByIdStatusByErrorCode[result.error.code],
      );
    }

    return c.json(
      {
        media: await toMediaResponse(c.get('supabase'), result.media, {
          includeMediaUrl: true,
        }),
      },
      200,
    );
  });
}
