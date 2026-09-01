/// A failure encountered while loading a profile.
sealed class ProfileFailure {
  /// Default constructor.
  const ProfileFailure();
}

/// The current session cannot access the profile.
final class UnauthenticatedProfileFailure extends ProfileFailure {
  /// Default constructor.
  const UnauthenticatedProfileFailure();
}

/// The supplied username is already in use.
final class UsernameUnavailableProfileFailure extends ProfileFailure {
  /// Default constructor.
  const UsernameUnavailableProfileFailure();
}

/// An unexpected profile operation failure.
final class UnknownProfileFailure extends ProfileFailure {
  /// Default constructor.
  const UnknownProfileFailure();
}
