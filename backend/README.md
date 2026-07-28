# Nook Backend

TypeScript backend for Nook, planned around Hono and deployment to Google Cloud Run.

This is currently the initial Node/TypeScript scaffold. Real API routes, Supabase integration, upload handling, and database migrations still need to be implemented.

## Role

- Act as the application layer between Flutter clients and Supabase
- Validate authenticated requests
- Coordinate media upload metadata
- Read and write media, collection, and tag records
- Keep storage-provider details abstract enough to allow future migration

## Development

From this directory:

```sh
npm install
npm test
```

The current `npm test` script is still the generated placeholder and will fail until real tests are added.

See `../PROJECT_CONTEXT.md` for product, architecture, and data-model context.
