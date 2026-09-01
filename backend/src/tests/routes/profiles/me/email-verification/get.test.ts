import { describe, expect, it, vi } from 'vitest';
import { createProfilesTestApp, testRequireSession } from '../test-utils.js';

vi.mock('../../../../../middleware/auth.js', () => ({
  requireSession: testRequireSession,
}));

const { registerGetEmailVerificationStatusRoute } = await import(
  '../../../../../routes/profiles/me/email-verification/get.js'
);

describe('GET /profiles/me/email-verification', () => {
  it('returns the authenticated session email verification status', async () => {
    const response = await createProfilesTestApp(
      registerGetEmailVerificationStatusRoute,
    ).request('/profiles/me/email-verification');

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({ is_email_verified: true });
  });
});
