/// A failure encountered while registering an account.
sealed class RegistrationFailure {
  /// Default constructor.
  const RegistrationFailure();
}

/// The supplied username is already in use.
final class UsernameUnavailableRegistrationFailure extends RegistrationFailure {
  /// Default constructor.
  const UsernameUnavailableRegistrationFailure();
}

/// The supplied email address is already registered.
final class EmailAlreadyRegisteredRegistrationFailure extends RegistrationFailure {
  /// Default constructor.
  const EmailAlreadyRegisteredRegistrationFailure();
}

/// An unexpected registration failure.
final class UnknownRegistrationFailure extends RegistrationFailure {
  /// Default constructor.
  const UnknownRegistrationFailure();
}
