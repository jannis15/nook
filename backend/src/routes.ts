import type { App } from './app-types.js';
import { registerGetHealthRoute } from './routes/health.js';
import { registerDeleteMediaByIdRoute } from './routes/media/{id}/delete.js';
import { registerCompleteMediaUploadRoute } from './routes/media/{id}/complete.js';
import { registerGetMediaByIdRoute } from './routes/media/{id}/get.js';
import { registerGetMediaStatusRoute } from './routes/media/{id}/status.js';
import { registerGetMediaListRoute } from './routes/media/get.js';
import { registerPostMediaRoute } from './routes/media/post.js';
import { registerPostEmailVerificationResendRoute } from './routes/profiles/email-verification/post.js';
import { registerGetEmailVerificationStatusRoute } from './routes/profiles/me/email-verification/get.js';
import { registerGetMeRoute } from './routes/profiles/me/get.js';
import { registerPostProfileRoute } from './routes/profiles/post.js';

export function registerRoutes(app: App) {
  registerGetHealthRoute(app);
  registerGetMediaListRoute(app);
  registerPostMediaRoute(app);
  registerCompleteMediaUploadRoute(app);
  registerGetMediaStatusRoute(app);
  registerGetMediaByIdRoute(app);
  registerDeleteMediaByIdRoute(app);
  registerPostProfileRoute(app);
  registerPostEmailVerificationResendRoute(app);
  registerGetEmailVerificationStatusRoute(app);
  registerGetMeRoute(app);
}
