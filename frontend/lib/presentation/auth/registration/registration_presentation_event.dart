/// A one-off event emitted by [RegistrationCubit].
sealed class RegistrationPresentationEvent {
  /// Default constructor.
  const RegistrationPresentationEvent();
}

/// Registration completed and email verification is required.
final class EmailVerificationRequired extends RegistrationPresentationEvent {
  /// Default constructor.
  const EmailVerificationRequired();
}

/// The submitted username is already in use.
final class RegistrationUsernameUnavailable extends RegistrationPresentationEvent {
  /// Default constructor.
  const RegistrationUsernameUnavailable();
}

/// Registration could not be submitted.
final class RegistrationSubmissionFailed extends RegistrationPresentationEvent {
  /// Default constructor.
  const RegistrationSubmissionFailed();
}
