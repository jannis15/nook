import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const originalEnv = { ...process.env };

describe('CORS', () => {
  beforeEach(() => {
    vi.resetModules();
    process.env = {
      ...originalEnv,
      CORS_ALLOWED_ORIGINS: 'http://localhost:3000,http://localhost:8080',
      SUPABASE_URL: 'http://127.0.0.1:54321',
      SUPABASE_SECRET_KEY: 'test-key',
    };
  });

  afterEach(() => {
    process.env = originalEnv;
  });

  it('allows configured origins', async () => {
    const { app } = await import('../../app.js');

    const response = await app.request('/health', {
      headers: {
        Origin: 'http://localhost:3000',
        'Access-Control-Request-Method': 'GET',
      },
      method: 'OPTIONS',
    });

    expect(response.status).toBe(204);
    expect(response.headers.get('access-control-allow-origin')).toBe(
      'http://localhost:3000',
    );
  });

  it('does not allow unconfigured origins', async () => {
    const { app } = await import('../../app.js');

    const response = await app.request('/health', {
      headers: {
        Origin: 'https://example.com',
        'Access-Control-Request-Method': 'GET',
      },
      method: 'OPTIONS',
    });

    expect(response.status).toBe(204);
    expect(response.headers.get('access-control-allow-origin')).toBeNull();
  });
});
