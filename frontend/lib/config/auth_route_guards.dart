import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/use_cases/watch_identity_use_case.dart';
import 'package:nook/domain/profile/use_cases/watch_own_profile_use_case.dart';

/// Redirects unauthenticated users to sign in.
class AuthRouteGuard extends AutoRouteGuard {
  /// Default constructor.
  const AuthRouteGuard(this._watchIdentity, this._watchOwnProfile);

  final WatchIdentityUseCase _watchIdentity;
  final WatchOwnProfileUseCase _watchOwnProfile;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final identity = _watchIdentity().value;
    if (identity case AuthenticatedAppIdentity(:final isEmailVerified)) {
      if (!isEmailVerified) {
        unawaited(router.pushPath('/auth/verify-email'));
        resolver.next(false);
        return;
      }

      if (_watchOwnProfile().value != null) {
        resolver.next();
        return;
      }

      unawaited(router.pushPath('/auth/loading'));
      resolver.next(false);
      return;
    }

    unawaited(router.pushPath('/auth/login'));
    resolver.next(false);
  }
}

/// Redirects authenticated users away from guest-only routes.
class GuestRouteGuard extends AutoRouteGuard {
  /// Default constructor.
  const GuestRouteGuard(this._watchIdentity);

  final WatchIdentityUseCase _watchIdentity;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_watchIdentity().value case AuthenticatedAppIdentity(:final isEmailVerified)) {
      unawaited(router.pushPath(isEmailVerified ? '/auth/loading' : '/auth/verify-email'));
      resolver.next(false);
      return;
    }

    resolver.next();
  }
}
