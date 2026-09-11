/// A one-off event emitted by [RegistrationCubit].
sealed class RegistrationPresentationEvent {
  /// Default constructor.
  const RegistrationPresentationEvent();
}

/// Registration completed and the user must verify their email address.
final class RegistrationCompleted extends RegistrationPresentationEvent {
  /// Default constructor.
  const RegistrationCompleted();
}

/// The submitted username is already in use.
final class RegistrationUsernameUnavailable extends RegistrationPresentationEvent {
  /// Default constructor.
  const RegistrationUsernameUnavailable();
}

/// The submitted email address is already registered.
final class RegistrationEmailAlreadyRegistered extends RegistrationPresentationEvent {
  /// Default constructor.
  const RegistrationEmailAlreadyRegistered();
}

/// Registration could not be submitted.
final class RegistrationSubmissionFailed extends RegistrationPresentationEvent {
  /// Default constructor.
  const RegistrationSubmissionFailed();
}
