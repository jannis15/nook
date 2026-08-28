import { spawn, spawnSync } from 'node:child_process';

const supabaseEnvNames = ['SUPABASE_URL', 'SUPABASE_SECRET_KEY'];

run('npm run supabase:ensure');

const status = spawnSync('npx supabase status -o env', {
  cwd: 'supabase',
  shell: true,
  encoding: 'utf8',
  stdio: ['inherit', 'pipe', 'inherit'],
});

if (status.status !== 0) {
  process.exit(status.status ?? 1);
}

const env = { ...process.env };

for (const line of status.stdout.split('\n')) {
  const match = line.match(/^([A-Z0-9_]+)="(.*)"$/);
  if (!match) continue;

  const name =
    match[1] === 'API_URL'
      ? 'SUPABASE_URL'
      : match[1] === 'SECRET_KEY'
        ? 'SUPABASE_SECRET_KEY'
        : null;
  if (name && supabaseEnvNames.includes(name)) {
    env[name] ??= match[2];
  }
}

for (const name of supabaseEnvNames) {
  if (!env[name]) {
    console.error(`Missing ${name} from Supabase status output.`);
    process.exit(1);
  }
}

const worker = spawn('tsx watch src/media-worker.ts', {
  shell: true,
  stdio: 'inherit',
  env,
});

worker.on('exit', (code, signal) => {
  if (signal) {
    process.kill(process.pid, signal);
    return;
  }
  process.exit(code ?? 0);
});

function run(command) {
  const result = spawnSync(command, { shell: true, stdio: 'inherit' });
  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}
