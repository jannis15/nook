sealed class AuthFailure {
  const AuthFailure();
}

final class InvalidCredentialsAuthFailure extends AuthFailure {
  const InvalidCredentialsAuthFailure();
}

final class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure();
}
