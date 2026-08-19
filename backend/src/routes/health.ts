import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../app-types.js';
import { openApiTags } from '../lib/openapi-tags.js';

const healthResponseSchema = z.object({
  status: z.literal('ok'),
});

const getHealthRoute = createRoute({
  method: 'get',
  path: '/health',
  tags: [openApiTags.health],
  responses: {
    200: {
      description: 'Backend is running',
      content: {
        'application/json': {
          schema: healthResponseSchema,
        },
      },
    },
  },
});

export function registerGetHealthRoute(app: App) {
  app.openapi(getHealthRoute, (c) => c.json({ status: 'ok' }, 200));
}
