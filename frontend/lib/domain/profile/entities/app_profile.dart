/// The profile of the current application user.
class AppProfile {
  /// Default constructor.
  const AppProfile({required this.id, required this.email, required this.username, required this.isUsernameConfigured});

  /// The stable user identifier.
  final String id;

  /// The user's email address.
  final String email;

  /// The user's username.
  final String username;

  /// Whether the user has selected a username.
  final bool isUsernameConfigured;
}
