import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';

class AuthRouteGuard extends AutoRouteGuard {
  const AuthRouteGuard(this._authRepository);

  final AuthRepository _authRepository;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_authRepository.currentIdentity.isAuthenticated) {
      resolver.next();
      return;
    }

    unawaited(router.pushPath('/auth/login'));
    resolver.next(false);
  }
}

class GuestRouteGuard extends AutoRouteGuard {
  const GuestRouteGuard(this._authRepository);

  final AuthRepository _authRepository;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_authRepository.currentIdentity.isAuthenticated) {
      unawaited(router.pushPath('/home'));
      resolver.next(false);
      return;
    }

    resolver.next();
  }
}
