/// The current email verification refresh state.
class EmailVerificationState {
  /// Default constructor.
  const EmailVerificationState({this.isRefreshing = false, this.isLoggingOut = false});

  /// Whether the verification state is being refreshed.
  final bool isRefreshing;

  /// Whether sign-out is in progress.
  final bool isLoggingOut;
}
