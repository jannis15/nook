import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { Supabase } from '../../lib/supabase.js';

const maybeSingle = vi.hoisted(() => vi.fn());
const createUser = vi.hoisted(() => vi.fn());
const deleteUser = vi.hoisted(() => vi.fn());
const resend = vi.hoisted(() => vi.fn());
const logger = vi.hoisted(() => ({ error: vi.fn(), info: vi.fn() }));
const env = vi.hoisted(() => ({ isLocalSupabase: false }));

vi.mock('../../lib/logger.js', () => ({ logger }));
vi.mock('../../env.js', () => ({ env }));

const { registerProfile } = await import(
  '../../domain/profile-registration-service.js'
);

const supabase = {
  from: vi.fn(() => ({
    select: () => ({
      eq: () => ({ maybeSingle }),
    }),
  })),
  auth: {
    admin: { createUser, deleteUser },
    resend,
  },
} as unknown as Supabase;

const input = {
  email: 'test@nook.local',
  password: 'password',
  username: 'test_user',
};

describe('profile registration service', () => {
  beforeEach(() => {
    maybeSingle.mockReset();
    createUser.mockReset();
    deleteUser.mockReset();
    resend.mockReset();
    logger.error.mockReset();
    logger.info.mockReset();
    env.isLocalSupabase = false;
  });

  it('creates an unverified user and sends a verification email', async () => {
    maybeSingle.mockResolvedValue({ data: null, error: null });
    createUser.mockResolvedValue({
      data: { user: { id: 'user-1' } },
      error: null,
    });
    resend.mockResolvedValue({ error: null });

    await expect(
      registerProfile(supabase, input, 'request-1'),
    ).resolves.toEqual({ ok: true });
    expect(createUser).toHaveBeenCalledWith({
      email: input.email,
      password: input.password,
      email_confirm: false,
      user_metadata: {
        username: input.username,
      },
    });
    expect(resend).toHaveBeenCalledWith({ type: 'signup', email: input.email });
  });

  it('returns a conflict without creating a user when the username is taken', async () => {
    maybeSingle.mockResolvedValue({ data: { id: 'user-1' }, error: null });

    await expect(
      registerProfile(supabase, input, 'request-1'),
    ).resolves.toEqual({
      ok: false,
      error: { code: 'conflict', message: 'Username is already taken' },
    });
    expect(createUser).not.toHaveBeenCalled();
  });

  it('auto-confirms a local registration without sending an email', async () => {
    env.isLocalSupabase = true;
    maybeSingle.mockResolvedValue({ data: null, error: null });
    createUser.mockResolvedValue({
      data: { user: { id: 'user-1' } },
      error: null,
    });

    await expect(
      registerProfile(supabase, input, 'request-1'),
    ).resolves.toEqual({ ok: true });
    expect(createUser).toHaveBeenCalledWith(
      expect.objectContaining({ email_confirm: true }),
    );
    expect(resend).not.toHaveBeenCalled();
  });

  it('returns an unknown error when Supabase rejects the password', async () => {
    maybeSingle.mockResolvedValue({ data: null, error: null });
    createUser.mockResolvedValue({
      data: { user: null },
      error: new Error('Password should be at least 6 characters'),
    });

    await expect(
      registerProfile(supabase, input, 'request-1'),
    ).resolves.toEqual({
      ok: false,
      error: {
        code: 'internal_server_error',
        message: 'Profile could not be created',
      },
    });
  });

  it('deletes the unverified user when the verification email cannot be sent', async () => {
    maybeSingle.mockResolvedValue({ data: null, error: null });
    createUser.mockResolvedValue({
      data: { user: { id: 'user-1' } },
      error: null,
    });
    resend.mockResolvedValue({ error: new Error('email unavailable') });
    deleteUser.mockResolvedValue({ error: null });

    await expect(
      registerProfile(supabase, input, 'request-1'),
    ).resolves.toMatchObject({
      ok: false,
      error: { code: 'internal_server_error' },
    });
    expect(deleteUser).toHaveBeenCalledWith('user-1');
  });
});
