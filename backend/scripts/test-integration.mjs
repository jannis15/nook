import { spawn, spawnSync } from 'node:child_process';

let status = getSupabaseStatus();

if (status.status !== 0) {
  startSupabase();
  status = getSupabaseStatus();
}

if (status.status !== 0) {
  process.exit(status.status ?? 1);
}

const env = { ...process.env };
const statusEnv = parseStatusEnv(status.stdout);

env.SUPABASE_URL ??= statusEnv.API_URL;
env.SUPABASE_PUBLISHABLE_KEY ??= statusEnv.PUBLISHABLE_KEY;
env.SUPABASE_SECRET_KEY ??= statusEnv.SECRET_KEY;

for (const name of [
  'SUPABASE_URL',
  'SUPABASE_PUBLISHABLE_KEY',
  'SUPABASE_SECRET_KEY',
]) {
  if (!env[name]) {
    console.error(`Missing ${name} from Supabase status output.`);
    process.exit(1);
  }
}

const tests = spawn('vitest run src/tests/integration/supabase-rls.test.ts', {
  shell: true,
  stdio: 'inherit',
  env,
});

tests.on('exit', (code, signal) => {
  if (signal) {
    process.kill(process.pid, signal);
    return;
  }

  process.exit(code ?? 0);
});

function getSupabaseStatus() {
  return spawnSync('npx supabase status -o env', {
    cwd: 'supabase',
    shell: true,
    encoding: 'utf8',
    stdio: ['inherit', 'pipe', 'ignore'],
  });
}

function parseStatusEnv(output) {
  const env = {};

  for (const line of output.split('\n')) {
    const match = line.match(/^([A-Z0-9_]+)="(.*)"$/);

    if (match) {
      env[match[1]] = match[2];
    }
  }

  return env;
}

function startSupabase() {
  const result = spawnSync('npx supabase start', {
    cwd: 'supabase',
    shell: true,
    stdio: ['inherit', 'ignore', 'inherit'],
  });

  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}
