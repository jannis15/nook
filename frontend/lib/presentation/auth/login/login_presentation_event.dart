sealed class LoginPresentationEvent {
  const LoginPresentationEvent();
}

final class LoginSubmissionFailed extends LoginPresentationEvent {
  const LoginSubmissionFailed();
}
