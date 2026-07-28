import type { App } from './app-types.js';
import { registerGetHealthRoute } from './routes/health.js';
import { registerGetMeRoute } from './routes/profiles/me/get.js';
import { registerPatchMeRoute } from './routes/profiles/me/patch.js';

export function registerRoutes(app: App) {
  registerGetHealthRoute(app);
  registerGetMeRoute(app);
  registerPatchMeRoute(app);
}
