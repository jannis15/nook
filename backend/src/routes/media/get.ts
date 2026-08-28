import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../../app-types.js';
import { listOwnMedia } from '../../domain/media-service.js';
import { apiError, errorResponseSchema } from '../../lib/errors.js';
import { openApiTags } from '../../lib/openapi-tags.js';
import { requireAuth } from '../../middleware/auth.js';
import { toMediaResponse } from './mapper.js';
import { mediaListResponseSchema } from './types.js';

type MediaCursor = {
  createdAt: string;
  id: string;
};

const mediaListQuerySchema = z.object({
  cursor: z.string().optional().transform(parseMediaCursor),
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
      ...(query.cursor ? { cursor: query.cursor } : {}),
      ...(query.media_type ? { mediaType: query.media_type } : {}),
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
        next_cursor: result.nextCursor
          ? encodeMediaCursor(result.nextCursor)
          : null,
      },
      200,
    );
  });
}

function parseMediaCursor(
  cursor: string | undefined,
  ctx: z.RefinementCtx,
): MediaCursor | undefined {
  if (!cursor) return undefined;

  try {
    const value: unknown = JSON.parse(
      Buffer.from(cursor, 'base64url').toString('utf8'),
    );
    if (
      typeof value === 'object' &&
      value !== null &&
      'createdAt' in value &&
      'id' in value &&
      typeof value.createdAt === 'string' &&
      !Number.isNaN(Date.parse(value.createdAt)) &&
      typeof value.id === 'string' &&
      z.uuid().safeParse(value.id).success
    ) {
      return { createdAt: value.createdAt, id: value.id };
    }
  } catch {
    // Invalid cursors are reported as request validation errors.
  }

  ctx.addIssue({ code: 'custom', message: 'Invalid cursor' });
  return z.NEVER;
}

function encodeMediaCursor(cursor: MediaCursor): string {
  return Buffer.from(JSON.stringify(cursor)).toString('base64url');
}
