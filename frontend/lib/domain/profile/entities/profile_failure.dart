sealed class ProfileFailure {
  const ProfileFailure();
}

final class UnauthenticatedProfileFailure extends ProfileFailure {
  const UnauthenticatedProfileFailure();
}

final class UnknownProfileFailure extends ProfileFailure {
  const UnknownProfileFailure();
}
