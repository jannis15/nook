import { Hono } from 'hono';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthVariables } from '../../middleware/auth.js';
import type { RequestVariables } from '../../middleware/request-id.js';

const getUser = vi.hoisted(() => vi.fn());
const createSupabaseAdminClient = vi.hoisted(() => vi.fn());
const supabase = vi.hoisted(() => ({
  auth: {
    getUser,
  },
}));
const logger = vi.hoisted(() => ({
  debug: vi.fn(),
  error: vi.fn(),
}));

vi.mock('../../lib/supabase.js', () => ({
  createSupabaseAdminClient,
}));

vi.mock('../../lib/logger.js', () => ({
  logger,
}));

const { requireAuth } = await import('../../middleware/auth.js');
const testRequestId = 'request-1';

describe('requireAuth', () => {
  beforeEach(() => {
    getUser.mockReset();
    createSupabaseAdminClient.mockReset();
    createSupabaseAdminClient.mockReturnValue(supabase);
  });

  it('rejects a missing authorization header', async () => {
    const response = await createTestApp().request('/protected');

    expect(response.status).toBe(401);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: 'missing_bearer_token',
        message: 'Missing bearer token',
      },
    });
    expect(createSupabaseAdminClient).not.toHaveBeenCalled();
  });

  it('rejects malformed authorization headers', async () => {
    for (const authorization of ['Basic token', 'Bearer', 'BearerToken']) {
      const response = await createTestApp().request('/protected', {
        headers: { authorization },
      });

      expect(response.status).toBe(401);
      await expect(response.json()).resolves.toEqual({
        error: {
          code: 'missing_bearer_token',
          message: 'Missing bearer token',
        },
      });
    }

    expect(createSupabaseAdminClient).not.toHaveBeenCalled();
  });

  it('rejects an empty bearer token', async () => {
    for (const authorization of ['Bearer ', 'Bearer    ']) {
      const response = await createTestApp().request('/protected', {
        headers: { authorization },
      });

      expect(response.status).toBe(401);
      await expect(response.json()).resolves.toEqual({
        error: {
          code: 'missing_bearer_token',
          message: 'Missing bearer token',
        },
      });
    }

    expect(createSupabaseAdminClient).not.toHaveBeenCalled();
  });

  it('accepts a case-insensitive bearer scheme and stores auth variables', async () => {
    getUser.mockResolvedValue({
      data: { user: { id: 'user-1' } },
      error: null,
    });

    const response = await createTestApp().request('/protected', {
      headers: { authorization: 'bearer access-token' },
    });

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({
      accessToken: 'access-token',
      hasSupabase: true,
      userId: 'user-1',
    });
    expect(createSupabaseAdminClient).toHaveBeenCalledOnce();
    expect(getUser).toHaveBeenCalledWith('access-token');
  });

  it('rejects an invalid bearer token', async () => {
    getUser.mockResolvedValue({
      data: { user: null },
      error: new Error('invalid'),
    });

    const response = await createTestApp().request('/protected', {
      headers: { authorization: 'Bearer access-token' },
    });

    expect(response.status).toBe(401);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: 'invalid_bearer_token',
        message: 'Invalid bearer token',
      },
    });
  });

  it('returns a typed error when auth verification fails', async () => {
    getUser.mockRejectedValue(new Error('auth unavailable'));

    const response = await createTestApp().request('/protected', {
      headers: { authorization: 'Bearer access-token' },
    });

    expect(response.status).toBe(500);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: 'internal_server_error',
        message: 'Unable to verify bearer token',
      },
    });
  });
});

function createTestApp() {
  const app = new Hono<{
    Variables: AuthVariables & RequestVariables;
  }>();

  app.use('/protected', async (c, next) => {
    c.set('requestId', testRequestId);
    await next();
  });
  app.use('/protected', requireAuth);
  app.get('/protected', (c) =>
    c.json({
      accessToken: c.get('accessToken'),
      hasSupabase: c.get('supabase') === supabase,
      userId: c.get('userId'),
    }),
  );

  return app;
}
