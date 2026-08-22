/// The authentication identity of the current application session.
sealed class AppIdentity {
  /// Default constructor.
  const AppIdentity();

  /// Whether this identity represents an authenticated user.
  bool get isAuthenticated => this is AuthenticatedAppIdentity;
}

/// An identity for a session without an authenticated user.
final class AnonymousAppIdentity extends AppIdentity {
  /// Default constructor.
  const AnonymousAppIdentity();
}

/// An identity for an authenticated user.
final class AuthenticatedAppIdentity extends AppIdentity {
  /// Default constructor.
  const AuthenticatedAppIdentity({required this.id});

  /// The stable user identifier.
  final String id;
}
