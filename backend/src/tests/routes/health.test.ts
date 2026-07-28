import { OpenAPIHono } from '@hono/zod-openapi';
import { describe, expect, it } from 'vitest';
import { registerGetHealthRoute } from '../../routes/health.js';

describe('GET /health', () => {
  it('returns ok', async () => {
    const app = new OpenAPIHono();
    registerGetHealthRoute(app);

    const response = await app.request('/health');

    await expect(response.json()).resolves.toEqual({ status: 'ok' });
    expect(response.status).toBe(200);
  });
});
