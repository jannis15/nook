insert into auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  confirmation_token,
  recovery_token,
  email_change_token_new,
  email_change,
  phone,
  phone_change,
  phone_change_token,
  email_change_token_current,
  reauthentication_token,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
) values (
  '00000000-0000-0000-0000-000000000000',
  '00000000-0000-0000-0000-000000000001',
  'authenticated',
  'authenticated',
  'test@nook.local',
  crypt('password', gen_salt('bf')),
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"display_name":"Test User"}',
  now(),
  now()
) on conflict (id) do update set
  encrypted_password = excluded.encrypted_password,
  confirmation_token = excluded.confirmation_token,
  recovery_token = excluded.recovery_token,
  email_change_token_new = excluded.email_change_token_new,
  email_change = excluded.email_change,
  phone = excluded.phone,
  phone_change = excluded.phone_change,
  phone_change_token = excluded.phone_change_token,
  email_change_token_current = excluded.email_change_token_current,
  reauthentication_token = excluded.reauthentication_token,
  email_confirmed_at = excluded.email_confirmed_at,
  raw_app_meta_data = excluded.raw_app_meta_data,
  raw_user_meta_data = excluded.raw_user_meta_data,
  updated_at = excluded.updated_at;

insert into auth.identities (
  provider_id,
  user_id,
  identity_data,
  provider,
  last_sign_in_at,
  created_at,
  updated_at
) values (
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000001',
  '{"sub":"00000000-0000-0000-0000-000000000001","email":"test@nook.local","email_verified":true,"phone_verified":false}',
  'email',
  now(),
  now(),
  now()
) on conflict (provider_id, provider) do nothing;

insert into public.profiles (id, display_name)
values ('00000000-0000-0000-0000-000000000001', 'Test User')
on conflict (id) do nothing;
