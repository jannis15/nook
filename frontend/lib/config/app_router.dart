import 'package:auto_route/auto_route.dart';
import 'package:nook/config/auth_route_guards.dart';
import 'package:nook/domain/auth/use_cases/watch_identity_use_case.dart';
import 'package:nook/presentation/auth/login/login_page.dart';
import 'package:nook/presentation/home/home_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter(this._watchIdentity);

  final WatchIdentityUseCase _watchIdentity;

  @override
  List<AutoRoute> get routes => [
    RedirectRoute(path: '/', redirectTo: '/home'),
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      initial: true,
      guards: [AuthRouteGuard(_watchIdentity)],
    ),
    AutoRoute(
      page: LoginRoute.page,
      path: '/auth/login',
      guards: [GuestRouteGuard(_watchIdentity)],
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ];
}
