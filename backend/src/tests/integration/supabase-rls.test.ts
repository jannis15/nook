import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import { describe, expect, it } from 'vitest';
import type { Database } from '../../db/types.js';

const runIntegration =
  process.env.RUN_SUPABASE_INTEGRATION === 'true' ||
  process.env.npm_lifecycle_event === 'test:integration';

const describeIntegration = runIntegration ? describe : describe.skip;

const supabaseUrl = process.env.SUPABASE_URL ?? 'http://127.0.0.1:54321';
const supabasePublishableKey =
  process.env.SUPABASE_PUBLISHABLE_KEY ??
  'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH';
const supabaseSecretKey =
  process.env.SUPABASE_SECRET_KEY ?? process.env.SECRET_KEY;

const seededUser = {
  id: '00000000-0000-0000-0000-000000000001',
  email: 'test@nook.local',
  password: 'password',
};

describeIntegration('Supabase profiles RLS integration', () => {
  it('creates a profile when a user signs up', async () => {
    const displayName = 'Integration Signup User';
    let userId: string | undefined;

    try {
      const signedUpUser = await signUpTestUser(displayName);
      userId = signedUpUser.userId;

      const { data, error } = await signedUpUser.client
        .from('profiles')
        .select('id, email, display_name')
        .eq('id', userId)
        .single();

      expect(error).toBeNull();
      expect(data).toEqual({
        id: userId,
        email: signedUpUser.email,
        display_name: displayName,
      });
    } finally {
      await deleteTestUser(userId);
    }
  });

  it('allows the seeded user to read and update their own profile', async () => {
    const client = await signInSeededUser();
    const displayName = `Seeded User ${Date.now()}`;

    try {
      const { data: profile, error: readError } = await client
        .from('profiles')
        .select('id, email, display_name')
        .eq('id', seededUser.id)
        .single();

      expect(readError).toBeNull();
      expect(profile).toEqual({
        id: seededUser.id,
        email: seededUser.email,
        display_name: 'Test User',
      });

      const { data: updatedProfile, error: updateError } = await client
        .from('profiles')
        .update({ display_name: displayName })
        .eq('id', seededUser.id)
        .select('id, email, display_name')
        .single();

      expect(updateError).toBeNull();
      expect(updatedProfile).toEqual({
        id: seededUser.id,
        email: seededUser.email,
        display_name: displayName,
      });
    } finally {
      await client
        .from('profiles')
        .update({ display_name: 'Test User' })
        .eq('id', seededUser.id);
    }
  });

  it('prevents one user from reading or updating another user profile', async () => {
    const seededClient = await signInSeededUser();
    const otherDisplayName = 'Integration Other User';
    let otherUserId: string | undefined;

    try {
      const otherUser = await signUpTestUser(otherDisplayName);
      const otherClient = otherUser.client;
      otherUserId = otherUser.userId;

      const { data: crossUserRead, error: crossUserReadError } =
        await seededClient
          .from('profiles')
          .select('id, display_name')
          .eq('id', otherUserId);

      expect(crossUserReadError).toBeNull();
      expect(crossUserRead).toEqual([]);

      const { data: crossUserUpdate, error: crossUserUpdateError } =
        await seededClient
          .from('profiles')
          .update({ display_name: 'Blocked Cross User Update' })
          .eq('id', otherUserId)
          .select('id, display_name');

      expect(crossUserUpdateError).toBeNull();
      expect(crossUserUpdate).toEqual([]);

      const { data: otherProfile, error: otherReadError } = await otherClient
        .from('profiles')
        .select('id, display_name')
        .eq('id', otherUserId)
        .single();

      expect(otherReadError).toBeNull();
      expect(otherProfile).toEqual({
        id: otherUserId,
        display_name: otherDisplayName,
      });
    } finally {
      await deleteTestUser(otherUserId);
    }
  });
});

async function signInSeededUser() {
  const client = createSupabaseClient();
  const { data, error } = await client.auth.signInWithPassword({
    email: seededUser.email,
    password: seededUser.password,
  });

  expect(error).toBeNull();
  expect(data.session?.access_token).toBeDefined();

  return createSupabaseClient(data.session?.access_token);
}

async function signUpTestUser(displayName: string) {
  const client = createSupabaseClient();
  const uniqueId = `${Date.now()}-${Math.random().toString(36).slice(2)}`;
  const email = `integration-${uniqueId}@nook.local`;

  const { data, error } = await client.auth.signUp({
    email,
    password: 'password',
    options: {
      data: {
        display_name: displayName,
      },
    },
  });

  expect(error).toBeNull();
  expect(data.session?.access_token).toBeDefined();
  expect(data.user?.id).toBeDefined();

  return {
    client: createSupabaseClient(data.session?.access_token),
    email,
    userId: data.user?.id ?? '',
  };
}

function createSupabaseClient(accessToken?: string): SupabaseClient<Database> {
  return createClient<Database>(supabaseUrl, supabasePublishableKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
    global: accessToken
      ? {
          headers: {
            Authorization: `Bearer ${accessToken}`,
          },
        }
      : undefined,
  });
}

async function deleteTestUser(userId: string | undefined) {
  if (!userId) {
    return;
  }

  const adminClient = createAdminSupabaseClient();
  const { error } = await adminClient.auth.admin.deleteUser(userId);

  expect(error).toBeNull();
}

function createAdminSupabaseClient(): SupabaseClient<Database> {
  if (!supabaseSecretKey) {
    throw new Error('Missing SUPABASE_SECRET_KEY for integration test cleanup');
  }

  return createClient<Database>(supabaseUrl, supabaseSecretKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });
}
