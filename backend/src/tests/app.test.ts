import { afterEach, describe, expect, it, vi } from 'vitest';

describe('docs routes', () => {
  afterEach(() => {
    vi.resetModules();
    vi.doUnmock('../env.js');
  });

  it('exposes OpenAPI and Swagger UI when docs are enabled', async () => {
    const app = await createApp({ docsEnabled: true });

    expect((await app.request('/openapi.json')).status).toBe(200);
    expect((await app.request('/docs')).status).toBe(200);
  });

  it('does not expose OpenAPI or Swagger UI when docs are disabled', async () => {
    const app = await createApp({ docsEnabled: false });

    expect((await app.request('/openapi.json')).status).toBe(404);
    expect((await app.request('/docs')).status).toBe(404);
  });
});

describe('request IDs', () => {
  afterEach(() => {
    vi.resetModules();
    vi.doUnmock('../env.js');
  });

  it('accepts an incoming x-request-id and returns it', async () => {
    const app = await createApp({ docsEnabled: true });

    const response = await app.request('/openapi.json', {
      headers: { 'x-request-id': 'request-1' },
    });

    expect(response.headers.get('x-request-id')).toBe('request-1');
  });

  it('generates an x-request-id when one is not provided', async () => {
    const app = await createApp({ docsEnabled: true });

    const response = await app.request('/openapi.json');

    expect(response.headers.get('x-request-id')).toMatch(
      /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/,
    );
  });
});

async function createApp({ docsEnabled }: { docsEnabled: boolean }) {
  vi.resetModules();
  vi.doMock('../env.js', () => ({
    env: {
      corsAllowedOrigins: ['http://localhost:3000'],
      docsEnabled,
      logLevel: 'silent',
      nodeEnv: docsEnabled ? 'development' : 'production',
      port: 3001,
      supabaseSecretKey: 'test-key',
      supabaseUrl: 'http://localhost:54321',
    },
  }));

  const { app } = await import('../app.js');

  return app;
}
