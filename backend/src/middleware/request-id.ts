import { randomUUID } from 'node:crypto';
import { createMiddleware } from 'hono/factory';

export type RequestVariables = {
  requestId: string;
};

export const requestIdHeader = 'x-request-id';

export const requestId = createMiddleware<{ Variables: RequestVariables }>(
  async (c, next) => {
    const requestId = c.req.header(requestIdHeader)?.trim() || randomUUID();

    c.set('requestId', requestId);
    c.header(requestIdHeader, requestId);

    await next();

    c.header(requestIdHeader, requestId);
  },
);
