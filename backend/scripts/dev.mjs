import { spawn, spawnSync } from 'node:child_process';

const supabaseEnvNames = ['SUPABASE_URL', 'SUPABASE_PUBLISHABLE_KEY'];

run('npm run supabase:ensure');

const status = spawnSync(
  'npx supabase status -o env --override-name api.url=SUPABASE_URL --override-name auth.publishable_key=SUPABASE_PUBLISHABLE_KEY',
  {
    cwd: 'supabase',
    shell: true,
    encoding: 'utf8',
    stdio: ['inherit', 'pipe', 'inherit'],
  },
);

if (status.status !== 0) {
  process.exit(status.status ?? 1);
}

const env = { ...process.env };

for (const line of status.stdout.split('\n')) {
  const match = line.match(/^([A-Z0-9_]+)="(.*)"$/);

  if (!match || !supabaseEnvNames.includes(match[1])) {
    continue;
  }

  env[match[1]] ??= match[2];
}

for (const name of supabaseEnvNames) {
  if (!env[name]) {
    console.error(`Missing ${name} from Supabase status output.`);
    process.exit(1);
  }
}

const app = spawn('tsx watch src/index.ts', {
  shell: true,
  stdio: 'inherit',
  env,
});

app.on('exit', (code, signal) => {
  if (signal) {
    process.kill(process.pid, signal);
    return;
  }

  process.exit(code ?? 0);
});

function run(command) {
  const result = spawnSync(command, {
    shell: true,
    stdio: 'inherit',
  });

  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}
