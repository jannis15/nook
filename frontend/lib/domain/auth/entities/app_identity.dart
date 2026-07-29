sealed class AppIdentity {
  const AppIdentity();

  bool get isAuthenticated => this is AuthenticatedAppIdentity;
}

final class AnonymousAppIdentity extends AppIdentity {
  const AnonymousAppIdentity();
}

final class AuthenticatedAppIdentity extends AppIdentity {
  const AuthenticatedAppIdentity({required this.id, this.email});

  final String id;
  final String? email;
}
