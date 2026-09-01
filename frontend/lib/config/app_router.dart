import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:nook/config/auth_route_guards.dart';
import 'package:nook/domain/auth/use_cases/watch_identity_use_case.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/profile/use_cases/watch_own_profile_use_case.dart';
import 'package:nook/presentation/auth/loading/auth_loading_page.dart';
import 'package:nook/presentation/auth/login/login_page.dart';
import 'package:nook/presentation/auth/registration/registration_page.dart';
import 'package:nook/presentation/auth/verification/email_verification_page.dart';
import 'package:nook/presentation/home/home_page.dart';
import 'package:nook/presentation/media/media_detail_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
/// The application's declarative route configuration.
class AppRouter extends RootStackRouter {
  /// Default constructor.
  AppRouter(this._watchIdentity, this._watchOwnProfile);

  final WatchIdentityUseCase _watchIdentity;
  final WatchOwnProfileUseCase _watchOwnProfile;

  @override
  List<AutoRoute> get routes => [
    RedirectRoute(path: '/', redirectTo: '/auth/loading'),
    AutoRoute(page: AuthLoadingRoute.page, path: '/auth/loading', initial: true),
    CustomRoute<void>(
      page: HomeRoute.page,
      path: '/home',
      guards: [AuthRouteGuard(_watchIdentity, _watchOwnProfile)],
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    AutoRoute(
      page: MediaDetailRoute.page,
      path: '/media/:mediaId',
      guards: [AuthRouteGuard(_watchIdentity, _watchOwnProfile)],
    ),
    AutoRoute(page: LoginRoute.page, path: '/auth/login', guards: [GuestRouteGuard(_watchIdentity)]),
    AutoRoute(page: RegistrationRoute.page, path: '/auth/register', guards: [GuestRouteGuard(_watchIdentity)]),
    AutoRoute(page: EmailVerificationRoute.page, path: '/auth/verify-email'),
    RedirectRoute(path: '*', redirectTo: '/'),
  ];
}
