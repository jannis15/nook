import { config } from 'dotenv';
import type { LevelWithSilent } from 'pino';

config({ path: '.env.local', quiet: true });

const nodeEnv = process.env.NODE_ENV ?? 'development';

export const env = {
  nodeEnv,
  docsEnabled: process.env.ENABLE_DOCS
    ? process.env.ENABLE_DOCS === 'true'
    : nodeEnv !== 'production',
  logLevel: optionalLogLevel(
    process.env.LOG_LEVEL ?? (nodeEnv === 'production' ? 'info' : 'debug'),
  ),
  port: optionalPort(process.env.PORT ?? '3001'),
  corsAllowedOrigins: optionalOrigins(
    process.env.CORS_ALLOWED_ORIGINS ??
      'http://localhost:3000,http://localhost:8080',
  ),
  cloudRunJobName: process.env.MEDIA_WORKER_JOB_NAME,
  gcpProjectId: process.env.GCP_PROJECT_ID,
  gcpRegion: process.env.GCP_REGION,
  supabaseUrl: requiredEnv('SUPABASE_URL'),
  supabaseSecretKey: requiredEnv('SUPABASE_SECRET_KEY'),
  isLocalSupabase: isLocalSupabaseUrl(requiredEnv('SUPABASE_URL')),
};

function optionalLogLevel(value: string): LevelWithSilent {
  const allowedLevels = new Set([
    'trace',
    'debug',
    'info',
    'warn',
    'error',
    'fatal',
    'silent',
  ]);

  if (!allowedLevels.has(value)) {
    throw new Error(`Invalid LOG_LEVEL: ${value}`);
  }

  return value as LevelWithSilent;
}

function requiredEnv(name: string): string {
  const value = process.env[name];

  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }

  return value;
}

function optionalPort(value: string): number {
  if (!/^\d+$/.test(value)) {
    throw new Error(`Invalid PORT: ${value}`);
  }

  const port = Number.parseInt(value, 10);

  if (port > 65535) {
    throw new Error(`Invalid PORT: ${value}`);
  }

  return port;
}

function optionalOrigins(value: string): string[] {
  const origins = value
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);

  if (origins.includes('*')) {
    throw new Error('CORS_ALLOWED_ORIGINS must list explicit origins, not *');
  }

  return origins;
}

function isLocalSupabaseUrl(value: string) {
  try {
    const hostname = new URL(value).hostname;
    return hostname === 'localhost' || hostname === '127.0.0.1';
  } catch {
    return false;
  }
}
