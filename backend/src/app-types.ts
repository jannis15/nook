import type { OpenAPIHono } from '@hono/zod-openapi';
import type { AuthVariables } from './middleware/auth.js';
import type { RequestVariables } from './middleware/request-id.js';

export type App = OpenAPIHono<{
  Variables: AuthVariables & RequestVariables;
}>;
