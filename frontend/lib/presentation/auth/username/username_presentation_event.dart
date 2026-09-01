/// A one-off event emitted by [UsernameCubit].
sealed class UsernamePresentationEvent {
  /// Default constructor.
  const UsernamePresentationEvent();
}

/// The profile username was completed.
final class UsernameCompleted extends UsernamePresentationEvent {
  /// Default constructor.
  const UsernameCompleted();
}

/// The requested username is already in use.
final class UsernameUnavailable extends UsernamePresentationEvent {
  /// Default constructor.
  const UsernameUnavailable();
}

/// The username could not be completed.
final class UsernameCompletionFailed extends UsernamePresentationEvent {
  /// Default constructor.
  const UsernameCompletionFailed();
}
