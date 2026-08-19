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

describeIntegration('Supabase backend-only data access integration', () => {
  it('creates a profile when a user signs up', async () => {
    const displayName = 'Integration Signup User';
    let userId: string | undefined;

    try {
      const signedUpUser = await signUpTestUser(displayName);
      userId = signedUpUser.userId;

      const { data, error } = await createAdminSupabaseClient()
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

  it('denies direct authenticated access to profiles', async () => {
    const client = await signInSeededUser();
    const { error: readError } = await client
      .from('profiles')
      .select('id, email, display_name')
      .eq('id', seededUser.id)
      .single();
    const { error: updateError } = await client
      .from('profiles')
      .update({ display_name: 'Blocked update' })
      .eq('id', seededUser.id);

    expect(readError).not.toBeNull();
    expect(updateError).not.toBeNull();
  });

  it('denies direct authenticated access to media', async () => {
    const client = await signInSeededUser();
    const { error: readError } = await client.from('media').select('id');
    const { error: insertError } = await client.from('media').insert({
      owner_id: seededUser.id,
      storage_key: `${seededUser.id}/media/blocked/original.jpg`,
      original_filename: 'blocked.jpg',
      media_type: 'image',
      mime_type: 'image/jpeg',
      file_size: 12345,
    });

    expect(readError).not.toBeNull();
    expect(insertError).not.toBeNull();
  });

  it('allows signed uploads without direct Storage access', async () => {
    const userClient = await signInSeededUser();
    const storageKey = `${seededUser.id}/media/signed-upload-test/original.jpg`;
    const adminClient = createAdminSupabaseClient();

    try {
      const { data, error } = await adminClient.storage
        .from('media')
        .createSignedUploadUrl(storageKey);
      expect(error).toBeNull();
      expect(data).not.toBeNull();

      const response = await fetch(data?.signedUrl ?? '', {
        method: 'PUT',
        body: 'test image',
        headers: {
          'content-type': 'image/jpeg',
          'x-upsert': 'false',
        },
      });
      expect(response.ok).toBe(true);

      const { data: objects, error: listError } = await userClient.storage
        .from('media')
        .list(`${seededUser.id}/media/signed-upload-test`);
      expect(listError).toBeNull();
      expect(objects).toEqual([]);
    } finally {
      await adminClient.storage.from('media').remove([storageKey]);
    }
  });

  it('allows service-role media writes and enforces constraints', async () => {
    const client = createAdminSupabaseClient();
    const mediaId = '10000000-0000-4000-8000-000000000001';

    try {
      const { error: insertError } = await client.from('media').insert({
        id: mediaId,
        owner_id: seededUser.id,
        storage_key: `${seededUser.id}/media/${mediaId}/original.jpg`,
        original_filename: 'integration-photo.jpg',
        media_type: 'image',
        mime_type: 'image/jpeg',
        file_size: 12345,
        status: 'ready',
        upload_expires_at: new Date().toISOString(),
      });

      expect(insertError).toBeNull();

      const { error: processingError } = await client
        .from('media')
        .update({
          processing_error: 'Unexpected error',
        })
        .eq('id', mediaId);

      expect(processingError).not.toBeNull();
    } finally {
      await client.from('media').delete().eq('id', mediaId);
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
