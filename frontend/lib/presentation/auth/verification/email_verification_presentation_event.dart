/// A one-off event emitted by [EmailVerificationCubit].
sealed class EmailVerificationPresentationEvent {
  /// Default constructor.
  const EmailVerificationPresentationEvent();
}

/// The current email verification state was refreshed.
final class EmailVerificationRefreshed extends EmailVerificationPresentationEvent {
  /// Default constructor.
  const EmailVerificationRefreshed();
}

/// The current email verification state could not be refreshed.
final class EmailVerificationRefreshFailed extends EmailVerificationPresentationEvent {
  /// Default constructor.
  const EmailVerificationRefreshFailed();
}

/// The email address is not verified yet.
final class EmailVerificationPending extends EmailVerificationPresentationEvent {
  /// Default constructor.
  const EmailVerificationPending();
}

/// The session was ended.
final class EmailVerificationLoggedOut extends EmailVerificationPresentationEvent {
  /// Default constructor.
  const EmailVerificationLoggedOut();
}

/// The session could not be ended.
final class EmailVerificationLogoutFailed extends EmailVerificationPresentationEvent {
  /// Default constructor.
  const EmailVerificationLogoutFailed();
}
