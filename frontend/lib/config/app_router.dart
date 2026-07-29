import 'package:auto_route/auto_route.dart';
import 'package:nook/config/auth_route_guards.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:nook/presentation/auth/login/login_page.dart';
import 'package:nook/presentation/home/home_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter(this._authRepository);

  final AuthRepository _authRepository;

  @override
  List<AutoRoute> get routes => [
    RedirectRoute(path: '/', redirectTo: '/home'),
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      initial: true,
      guards: [AuthRouteGuard(_authRepository)],
    ),
    AutoRoute(
      page: LoginRoute.page,
      path: '/auth/login',
      guards: [GuestRouteGuard(_authRepository)],
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ];
}
