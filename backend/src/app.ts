import { swaggerUI } from '@hono/swagger-ui';
import { cors } from 'hono/cors';
import { env } from './env.js';
import { apiError } from './lib/errors.js';
import { logger } from './lib/logger.js';
import { createOpenAPIApp } from './lib/openapi.js';
import { requestId } from './middleware/request-id.js';
import type { App } from './app-types.js';
import { registerRoutes } from './routes.js';

export const app: App = createOpenAPIApp({
  onUnhandledError: (error, c) => {
    logger.error(
      {
        error,
        method: c.req.method,
        path: new URL(c.req.url).pathname,
        requestId: c.get('requestId'),
      },
      'Unhandled request error',
    );
  },
});

app.use(requestId);

app.use(
  '*',
  cors({
    origin: env.corsAllowedOrigins,
    allowHeaders: ['Authorization', 'Content-Type', 'X-Request-Id'],
    allowMethods: ['GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS'],
  }),
);

app.openAPIRegistry.registerComponent('securitySchemes', 'bearerAuth', {
  type: 'http',
  scheme: 'bearer',
});

app.use(async (c, next) => {
  const start = Date.now();
  const path = new URL(c.req.url).pathname;
  const method = c.req.method;
  const requestId = c.get('requestId');

  logger.debug({ method, path, requestId }, 'Request started');

  try {
    await next();
    logger.debug(
      {
        method,
        path,
        requestId,
        status: c.res.status,
        durationMs: Date.now() - start,
      },
      'Request completed',
    );
  } catch (error) {
    logger.debug(
      {
        error,
        method,
        path,
        requestId,
        status: 500,
        durationMs: Date.now() - start,
      },
      'Request failed',
    );
    throw error;
  }
});

registerRoutes(app);

if (env.docsEnabled) {
  app.doc('/openapi.json', {
    openapi: '3.1.0',
    info: {
      title: 'Nook Backend API',
      version: '0.1.0',
    },
  });

  app.get('/docs', swaggerUI({ url: '/openapi.json' }));
}

app.notFound((c) => c.json(apiError('not_found', 'Not found'), 404));
