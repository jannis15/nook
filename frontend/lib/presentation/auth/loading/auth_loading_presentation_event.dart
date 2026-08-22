/// A one-off event emitted while resolving the authenticated profile.
sealed class AuthLoadingPresentationEvent {
  /// Default constructor.
  const AuthLoadingPresentationEvent();
}

/// Authentication is no longer active.
final class AuthenticationRequired extends AuthLoadingPresentationEvent {
  /// Default constructor.
  const AuthenticationRequired();
}

/// The authenticated user's profile is available.
final class AuthenticatedProfileLoaded extends AuthLoadingPresentationEvent {
  /// Default constructor.
  const AuthenticatedProfileLoaded();
}
