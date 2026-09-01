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

/// An unexpected registration failure.
final class UnknownRegistrationFailure extends RegistrationFailure {
  /// Default constructor.
  const UnknownRegistrationFailure();
}
