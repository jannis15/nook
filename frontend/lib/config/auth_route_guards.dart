import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:nook/domain/auth/use_cases/watch_identity_use_case.dart';

class AuthRouteGuard extends AutoRouteGuard {
  const AuthRouteGuard(this._watchIdentity);

  final WatchIdentityUseCase _watchIdentity;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_watchIdentity().value.isAuthenticated) {
      resolver.next();
      return;
    }

    unawaited(router.pushPath('/auth/login'));
    resolver.next(false);
  }
}

class GuestRouteGuard extends AutoRouteGuard {
  const GuestRouteGuard(this._watchIdentity);

  final WatchIdentityUseCase _watchIdentity;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_watchIdentity().value.isAuthenticated) {
      unawaited(router.pushPath('/home'));
      resolver.next(false);
      return;
    }

    resolver.next();
  }
}
