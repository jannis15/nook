/// The profile of the current application user.
class AppProfile {
  /// Default constructor.
  const AppProfile({required this.id, required this.displayName, required this.email});

  /// The stable user identifier.
  final String id;

  /// The user's display name, when set.
  final String? displayName;

  /// The user's email address.
  final String email;
}
