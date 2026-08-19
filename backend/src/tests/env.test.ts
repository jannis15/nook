import { afterEach, describe, expect, it, vi } from 'vitest';

const originalEnv = { ...process.env };

describe('env docsEnabled', () => {
  afterEach(() => {
    vi.resetModules();
    process.env = { ...originalEnv };
  });

  it('enables docs outside production by default', async () => {
    const env = await importEnv({ NODE_ENV: 'development' });

    expect(env.docsEnabled).toBe(true);
  });

  it('disables docs in production by default', async () => {
    const env = await importEnv({ NODE_ENV: 'production' });

    expect(env.docsEnabled).toBe(false);
  });

  it('allows production docs with an explicit flag', async () => {
    const env = await importEnv({
      ENABLE_DOCS: 'true',
      NODE_ENV: 'production',
    });

    expect(env.docsEnabled).toBe(true);
  });
});

describe('env port', () => {
  afterEach(() => {
    vi.resetModules();
    process.env = { ...originalEnv };
  });

  it('defaults to port 3001', async () => {
    const env = await importEnv({ PORT: undefined });

    expect(env.port).toBe(3001);
  });

  it('rejects invalid port values', async () => {
    await expect(importEnv({ PORT: 'abc' })).rejects.toThrow(
      'Invalid PORT: abc',
    );
    await expect(importEnv({ PORT: '3001abc' })).rejects.toThrow(
      'Invalid PORT: 3001abc',
    );
    await expect(importEnv({ PORT: '65536' })).rejects.toThrow(
      'Invalid PORT: 65536',
    );
  });
});

async function importEnv(overrides: NodeJS.ProcessEnv) {
  vi.resetModules();
  process.env = {
    ...originalEnv,
    ENABLE_DOCS: undefined,
    NODE_ENV: undefined,
    PORT: undefined,
    SUPABASE_SECRET_KEY: 'test-key',
    SUPABASE_URL: 'http://localhost:54321',
    ...overrides,
  };

  const { env } = await import('../env.js');

  return env;
}
