import { beforeEach, describe, expect, it, vi } from 'vitest';
import { createProfilesTestApp, testRequestId } from '../me/test-utils.js';

const resendEmailVerification = vi.hoisted(() => vi.fn());
const createSupabaseAdminClient = vi.hoisted(() => vi.fn());
const supabase = {};

vi.mock('../../../../domain/email-verification-service.js', () => ({
  resendEmailVerification,
}));
vi.mock('../../../../lib/supabase.js', () => ({
  createSupabaseAdminClient,
}));

const { registerPostEmailVerificationResendRoute } = await import(
  '../../../../routes/profiles/email-verification/post.js'
);

describe('POST /profiles/email-verification/resend', () => {
  beforeEach(() => {
    resendEmailVerification.mockReset();
    createSupabaseAdminClient.mockReset();
    createSupabaseAdminClient.mockReturnValue(supabase);
  });

  it('requests a verification email resend', async () => {
    const response = await createProfilesTestApp(
      registerPostEmailVerificationResendRoute,
    ).request('/profiles/email-verification/resend', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ email: 'test@nook.local' }),
    });

    expect(response.status).toBe(204);
    expect(resendEmailVerification).toHaveBeenCalledWith(
      supabase,
      'test@nook.local',
      testRequestId,
    );
  });

  it('rejects an invalid email', async () => {
    const response = await createProfilesTestApp(
      registerPostEmailVerificationResendRoute,
    ).request('/profiles/email-verification/resend', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ email: 'invalid' }),
    });

    expect(response.status).toBe(400);
    expect(resendEmailVerification).not.toHaveBeenCalled();
  });
});
