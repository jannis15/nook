/// A one-off event emitted by [LoginCubit].
sealed class LoginPresentationEvent {
  /// Default constructor.
  const LoginPresentationEvent();
}

/// Login credentials could not be submitted.
final class LoginSubmissionFailed extends LoginPresentationEvent {
  /// Default constructor.
  const LoginSubmissionFailed();
}
