import { describe, expect, it, vi } from 'vitest';
import { createOpenAPIApp } from '../../lib/openapi.js';

describe('createOpenAPIApp', () => {
  it('returns a validation error for malformed JSON parse failures', async () => {
    const app = createOpenAPIApp();

    app.post('/parse-json', async (c) => c.json(await c.req.json()));

    const response = await app.request('/parse-json', {
      method: 'POST',
      headers: {
        'content-type': 'application/json',
      },
      body: '{',
    });

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      error: {
        code: 'validation_error',
        message: 'Invalid request',
      },
    });
  });

  it('does not treat unrelated JSON runtime errors as parse failures', async () => {
    const onUnhandledError = vi.fn();
    const app = createOpenAPIApp({ onUnhandledError });
    const error = new Error('JSON serializer failed');

    app.get('/throws-json-error', () => {
      throw error;
    });

    const response = await app.request('/throws-json-error');

    expect(response.status).toBe(500);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: 'internal_server_error',
        message: 'Internal server error',
      },
    });
    expect(onUnhandledError).toHaveBeenCalledWith(error, expect.anything());
  });
});
