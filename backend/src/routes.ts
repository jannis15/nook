import type { App } from './app-types.js';
import { registerGetHealthRoute } from './routes/health.js';
import { registerDeleteMediaByIdRoute } from './routes/media/{id}/delete.js';
import { registerCompleteMediaUploadRoute } from './routes/media/{id}/complete.js';
import { registerGetMediaByIdRoute } from './routes/media/{id}/get.js';
import { registerGetMediaStatusRoute } from './routes/media/{id}/status.js';
import { registerGetMediaListRoute } from './routes/media/get.js';
import { registerPostMediaRoute } from './routes/media/post.js';
import { registerGetMeRoute } from './routes/profiles/me/get.js';
import { registerPatchMeRoute } from './routes/profiles/me/patch.js';

export function registerRoutes(app: App) {
  registerGetHealthRoute(app);
  registerGetMediaListRoute(app);
  registerPostMediaRoute(app);
  registerCompleteMediaUploadRoute(app);
  registerGetMediaStatusRoute(app);
  registerGetMediaByIdRoute(app);
  registerDeleteMediaByIdRoute(app);
  registerGetMeRoute(app);
  registerPatchMeRoute(app);
}
