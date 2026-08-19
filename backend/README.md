# Nook Backend

TypeScript backend for Nook, built around Hono and local Supabase during early development.

This is currently the backend foundation: local Supabase Auth/PostgreSQL, request validation, OpenAPI docs, health checks, authenticated profile and media APIs, and tests. Gallery, collection, tag, and search APIs are future product work and are not part of the immediate implementation scope.

## Role

- Act as the application layer between Flutter clients and Supabase
- Validate authenticated requests
- Coordinate media upload metadata and direct-to-storage uploads
- Read and delete media records
- Eventually read and write collection and tag records
- Keep storage-provider details abstract enough to allow future migration

## Development

From this directory:

```sh
npm install
cp .env.example .env.local
npm run dev
npm run supabase:status
```

`npm run dev` checks whether local Supabase is running, starts it if needed, and then starts the Hono backend watcher.

Use the values from `npm run supabase:status` to update `.env.local`, including `SUPABASE_SECRET_KEY`, if your local values differ. Do not expose this key to clients.

The Hono server runs on `http://localhost:3001` by default. API documentation is generated from the route schemas and is available at `http://localhost:3001/docs`.

Profile routes require `Authorization: Bearer <access-token>`. They intentionally work with the app profile from `public.profiles`, not the full Supabase Auth identity.

See [Media Upload and Read Flow](docs/media-upload-flow.md) for the current
upload lifecycle, storage protections, read URLs, and content-hash status.

Manual API tests are available in `backend/bruno/`. They mirror endpoint paths in folders and use the documented method order from `backend/bruno/README.md`.

Database types are generated from the local Supabase schema:

```sh
npm run db:types
```

`npm run db:reset` loads `supabase/seed.sql`, which creates a local test user:

- Email: `test@nook.local`
- Password: `password`
- User id: `00000000-0000-0000-0000-000000000001`

New Supabase Auth users automatically get a `public.profiles` row through a database trigger. To manually verify the signup path after `npm run db:reset` and `npm run dev`:

```sh
curl -s -X POST "$SUPABASE_URL/auth/v1/signup" \
  -H "apikey: $SUPABASE_PUBLISHABLE_KEY" \
  -H "content-type: application/json" \
  -d '{"email":"new-user@nook.local","password":"password","data":{"display_name":"New User"}}'

curl -s "$SUPABASE_URL/rest/v1/profiles?select=id,display_name&display_name=eq.New%20User" \
  -H "apikey: $SUPABASE_PUBLISHABLE_KEY" \
  -H "Authorization: Bearer <signup-access-token>"

curl -s "http://localhost:3001/profiles/me" \
  -H "Authorization: Bearer <signup-access-token>"
```

Run the backend test suite with:

```sh
npm test
```

Supabase integration tests require local Supabase to be running and seeded:

```sh
npm run supabase:ensure
npm run db:reset
npm run test:integration
```

If your local Supabase keys differ from the defaults, set `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, and `SUPABASE_SECRET_KEY` before running `npm run test:integration`.

See `../PROJECT_CONTEXT.md` for product, architecture, and data-model context.
