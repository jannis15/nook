import { createRoute, z } from '@hono/zod-openapi';
import type { App } from '../app-types.js';

const healthResponseSchema = z.object({
  status: z.literal('ok'),
});

const getHealthRoute = createRoute({
  method: 'get',
  path: '/health',
  tags: ['Health'],
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
