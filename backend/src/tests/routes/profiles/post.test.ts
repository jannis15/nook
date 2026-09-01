import { beforeEach, describe, expect, it, vi } from 'vitest';
import { createProfilesTestApp, testRequestId } from './me/test-utils.js';

const registerProfile = vi.hoisted(() => vi.fn());
const createSupabaseAdminClient = vi.hoisted(() => vi.fn());
const supabase = {};

vi.mock('../../../domain/profile-registration-service.js', () => ({
  registerProfile,
}));
vi.mock('../../../lib/supabase.js', () => ({ createSupabaseAdminClient }));

const { registerPostProfileRoute } = await import(
  '../../../routes/profiles/post.js'
);

describe('POST /profiles', () => {
  beforeEach(() => {
    registerProfile.mockReset();
    createSupabaseAdminClient.mockReset();
    createSupabaseAdminClient.mockReturnValue(supabase);
  });

  it('creates a profile and sends email verification', async () => {
    registerProfile.mockResolvedValue({ ok: true });

    const response = await createProfilesTestApp(
      registerPostProfileRoute,
    ).request('/profiles', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({
        email: 'test@nook.local',
        password: 'StrongPass1!',
        username: 'test_user',
      }),
    });

    expect(response.status).toBe(201);
    await expect(response.json()).resolves.toEqual({
      message: 'Verification email sent',
    });
    expect(registerProfile).toHaveBeenCalledWith(
      supabase,
      {
        email: 'test@nook.local',
        password: 'StrongPass1!',
        username: 'test_user',
      },
      testRequestId,
    );
  });

  it('returns a conflict when the username is already taken', async () => {
    registerProfile.mockResolvedValue({
      ok: false,
      error: { code: 'conflict', message: 'Username is already taken' },
    });

    const response = await createProfilesTestApp(
      registerPostProfileRoute,
    ).request('/profiles', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({
        email: 'test@nook.local',
        password: 'StrongPass1!',
        username: 'test_user',
      }),
    });

    expect(response.status).toBe(409);
    await expect(response.json()).resolves.toEqual({
      error: { code: 'conflict', message: 'Username is already taken' },
    });
  });

  it.each([
    {},
    { email: 'test@nook.local', password: 'StrongPass1!' },
    {
      email: 'test@nook.local',
      password: 'StrongPass1!',
      username: 'Not Valid',
    },
    { email: 'test@nook.local', password: 'Short1!', username: 'test_user' },
    {
      email: 'test@nook.local',
      password: 'nouppercase1!',
      username: 'test_user',
    },
    {
      email: 'test@nook.local',
      password: 'NOLOWERCASE1!',
      username: 'test_user',
    },
    {
      email: 'test@nook.local',
      password: 'NoNumberPassword!',
      username: 'test_user',
    },
    {
      email: 'test@nook.local',
      password: 'NoSpecialPassword1',
      username: 'test_user',
    },
  ])('rejects invalid registration input', async (body) => {
    const response = await createProfilesTestApp(
      registerPostProfileRoute,
    ).request('/profiles', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify(body),
    });

    expect(response.status).toBe(400);
    expect(registerProfile).not.toHaveBeenCalled();
  });
});
