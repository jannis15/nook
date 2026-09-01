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

## Production: Google Cloud Run

Deploy the API to Cloud Run. Supabase remains the managed Auth, PostgreSQL, and
Storage provider; only `SUPABASE_SECRET_KEY` belongs in Secret Manager.

Prerequisites: a billing-enabled Google Cloud project, the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install), and a rotated Supabase service-role key. The existing `.env.staging` contains a service-role key and must not be used as a deployment configuration source.

From `backend/`, authenticate and select the project and region:

```sh
gcloud auth login
gcloud config set project nook-media
gcloud config set run/region europe-west1
gcloud services enable run.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com secretmanager.googleapis.com
```

Create a dedicated runtime service account and secret. Enter the newly rotated
key without adding it to a file:

```sh
gcloud iam service-accounts create nook-api --display-name="Nook API"
read -s SUPABASE_SECRET_KEY
printf %s "$SUPABASE_SECRET_KEY" | gcloud secrets create nook-supabase-secret-key --data-file=- --replication-policy=automatic
unset SUPABASE_SECRET_KEY
gcloud secrets add-iam-policy-binding nook-supabase-secret-key --member="serviceAccount:nook-api@nook-media.iam.gserviceaccount.com" --role="roles/secretmanager.secretAccessor"
```

If the secret already exists, replace the `create` command with:

```sh
printf %s "$SUPABASE_SECRET_KEY" | gcloud secrets versions add nook-supabase-secret-key --data-file=-
```

Deploy the API, replacing the project ID, region, Supabase URL, and allowed
origins where needed. The `^@^` delimiter permits the comma-separated CORS
origin list.

```sh
gcloud run deploy nook-api \
  --source . \
  --allow-unauthenticated \
  --service-account=nook-api@nook-media.iam.gserviceaccount.com \
  --set-env-vars '^@^NODE_ENV=production@CORS_ALLOWED_ORIGINS=https://nook-media.web.app@SUPABASE_URL=https://YOUR_PROJECT.supabase.co' \
  --set-secrets=SUPABASE_SECRET_KEY=nook-supabase-secret-key:latest
```

Cloud Run prints the service URL. Verify it before configuring the Flutter app:

```sh
curl -i "$(gcloud run services describe nook-api --format='value(status.url)')/health"
```

Set that HTTPS URL as the frontend API base URL, rebuild the Flutter web app,
and deploy it. If the frontend uses a custom domain, add it to
`CORS_ALLOWED_ORIGINS` and redeploy the API. API documentation is disabled in
production by default; set `ENABLE_DOCS=true` only if it is intentionally
public.

The media processor is not deployed by the API command. It polls for jobs and
requires `ffmpeg` and `ffprobe`, so deploy it separately as a Cloud Run job or
another worker process with the same Supabase secret.

## OAuth setup

Supabase brokers Google and GitHub OAuth and issues the session consumed by the Flutter client. The API validates the resulting Supabase bearer token and provisions the required Nook profile through the database trigger.

1. Apply `supabase/migrations/20260901000001_add_profile_username_completion.sql` to the hosted Supabase project.
2. In Supabase Dashboard, enable Google and GitHub under Authentication > Sign In / Up and provide each provider's client ID and client secret.
3. Register `https://<project-ref>.supabase.co/auth/v1/callback` in both provider consoles.
4. Set the web Site URL and allowed web and Android redirect URLs in Supabase Authentication URL configuration.

OAuth-provider email addresses are verified by Supabase. New OAuth profiles are marked as requiring a username; the frontend blocks application routes until the user completes that required step.

## Development

From this directory:

```sh
npm install
cp .env.example .env.local
npm run dev
npm run supabase:status
```

`npm run dev` checks whether local Supabase is running, starts it if needed, and then starts the Hono backend watcher.

Run the media processor in a second terminal after starting the API:

```sh
npm run worker:dev
```

The worker claims `processing` uploads, produces `preview.webp` and its
BlurHash, then marks the media ready. Video processing requires `ffmpeg` and
`ffprobe` on `PATH`; on macOS install them with `brew install ffmpeg`. Use
`npm run worker:once` to process one claimed batch with an already configured
Supabase environment.

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
