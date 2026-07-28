# Bruno Manual Tests

Manual API tests live in this Bruno collection. Run the backend with local Supabase before using it:

```sh
npm run dev
```

Select the `Local` Bruno environment. Set `supabasePublishableKey` to the local publishable/anon key from `npm run supabase:status` if it differs from your machine.

## Authentication

Run `authenticate/Local Sign In` first. It signs in with the seeded local user through local Supabase and stores `accessToken` as a secret in the selected Bruno environment.

You do not need to paste the bearer token into each request. Requests under `profiles/` inherit bearer auth from the folder and use `{{accessToken}}` automatically.

Seeded local user:

- Email: `test@nook.local`
- Password: `password`

## Layout

Request files mirror endpoint paths from the URL path. For example, `/profiles/me` is stored under `profiles/me/`.

Use one request file per HTTP method. Name request files exactly like their Bruno `meta.name` value:

- `My Profile.bru`
- `Update My Profile.bru`

Keep method order everywhere through the Bruno `seq` field: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`.

Backend endpoint requests mirror the backend URL path. Helper requests that do not represent backend endpoints live in purpose-named folders, such as `authenticate/`.
