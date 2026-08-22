/// A one-off event emitted by [MainAppBarCubit].
sealed class MainAppBarPresentationEvent {
  /// Default constructor.
  const MainAppBarPresentationEvent();
}

/// Sign-out could not be completed.
final class MainAppBarLogoutFailed extends MainAppBarPresentationEvent {
  /// Default constructor.
  const MainAppBarLogoutFailed();
}
