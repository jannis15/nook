/// The state of authenticated profile resolution.
sealed class AuthLoadingState {
  /// Default constructor.
  const AuthLoadingState();

  /// Displays progress while resolving the authenticated profile.
  const factory AuthLoadingState.loading() = AuthLoadingLoading;

  /// Displays recovery actions after profile resolution fails.
  const factory AuthLoadingState.error() = AuthLoadingError;
}

/// Displays progress while resolving the authenticated profile.
final class AuthLoadingLoading extends AuthLoadingState {
  /// Default constructor.
  const AuthLoadingLoading();
}

/// Displays recovery actions after profile resolution fails.
final class AuthLoadingError extends AuthLoadingState {
  /// Default constructor.
  const AuthLoadingError();
}
