import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../app-types.js';
import { listOwnMedia } from '../../domain/media-service.js';
import { apiError, errorResponseSchema } from '../../lib/errors.js';
import { openApiTags } from '../../lib/openapi-tags.js';
import { requireAuth } from '../../middleware/auth.js';
import { toMediaResponse } from './mapper.js';
import { mediaListResponseSchema } from './types.js';

const mediaListQuerySchema = z.object({
  media_type: z.enum(['image', 'video']).optional(),
  limit: z.coerce.number().int().min(1).max(100).default(50),
});

const getMediaListRoute = createRoute({
  method: 'get',
  path: '/media',
  tags: [openApiTags.media],
  middleware: [requireAuth] as const,
  security: [{ bearerAuth: [] }],
  request: {
    query: mediaListQuerySchema,
  },
  responses: {
    200: {
      description: 'Authenticated user media list',
      content: {
        'application/json': {
          schema: mediaListResponseSchema,
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
    500: {
      description: 'Media list failed',
      content: {
        'application/json': {
          schema: errorResponseSchema,
        },
      },
    },
  },
});

export function registerGetMediaListRoute(app: App) {
  app.openapi(getMediaListRoute, async (c) => {
    const query = c.req.valid('query');
    const filters = {
      limit: query.limit,
      ...(query.media_type ? { mediaType: query.media_type } : {}),
      status: 'ready' as const,
    };
    const result = await listOwnMedia(
      c.get('supabase'),
      c.get('userId'),
      filters,
      c.get('requestId'),
    );

    if (!result.ok) {
      return c.json(apiError(result.error.code, result.error.message), 500);
    }

    return c.json(
      {
        media: await Promise.all(
          result.media.map((media) =>
            toMediaResponse(c.get('supabase'), media),
          ),
        ),
      },
      200,
    );
  });
}
