/// A failure encountered during authentication.
sealed class AuthFailure {
  /// Default constructor.
  const AuthFailure();
}

/// Credentials were not accepted.
final class InvalidCredentialsAuthFailure extends AuthFailure {
  /// Default constructor.
  const InvalidCredentialsAuthFailure();
}

/// An unexpected authentication failure.
final class UnknownAuthFailure extends AuthFailure {
  /// Default constructor.
  const UnknownAuthFailure();
}
