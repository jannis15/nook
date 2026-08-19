import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../../app-types.js';
import { deleteOwnMediaById } from '../../../domain/media-service.js';
import { apiError, errorResponseSchema } from '../../../lib/errors.js';
import { openApiTags } from '../../../lib/openapi-tags.js';
import { requireAuth } from '../../../middleware/auth.js';

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

const deleteMediaByIdStatusByErrorCode = {
  not_found: 404,
  internal_server_error: 500,
} as const;

const deleteMediaByIdRoute = createRoute({
  method: 'delete',
  path: '/media/{id}',
  tags: [openApiTags.media],
  middleware: [requireAuth] as const,
  security: [{ bearerAuth: [] }],
  request: {
    params: mediaParamsSchema,
  },
  responses: {
    204: {
      description: 'Media deleted',
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
      description: 'Media deletion failed',
      content: {
        'application/json': {
          schema: errorResponseSchema,
        },
      },
    },
  },
});

export function registerDeleteMediaByIdRoute(app: App) {
  app.openapi(deleteMediaByIdRoute, async (c) => {
    const params = c.req.valid('param');
    const result = await deleteOwnMediaById(
      c.get('supabase'),
      c.get('userId'),
      params.id,
      c.get('requestId'),
    );

    if (!result.ok) {
      return c.json(
        apiError(result.error.code, result.error.message),
        deleteMediaByIdStatusByErrorCode[result.error.code],
      );
    }

    return c.body(null, 204);
  });
}
