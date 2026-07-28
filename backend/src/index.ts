import { serve } from '@hono/node-server';
import { app } from './app.js';
import { env } from './env.js';
import { logger } from './lib/logger.js';

serve({
  fetch: app.fetch,
  port: env.port,
});

logger.info(
  { url: `http://localhost:${env.port}`, logLevel: env.logLevel },
  'Backend listening',
);
