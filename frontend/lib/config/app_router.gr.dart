// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AuthLoadingPage]
class AuthLoadingRoute extends PageRouteInfo<void> {
  const AuthLoadingRoute({List<PageRouteInfo>? children})
    : super(AuthLoadingRoute.name, initialChildren: children);

  static const String name = 'AuthLoadingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthLoadingPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [RegistrationPage]
class RegistrationRoute extends PageRouteInfo<void> {
  const RegistrationRoute({List<PageRouteInfo>? children})
    : super(RegistrationRoute.name, initialChildren: children);

  static const String name = 'RegistrationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegistrationPage();
    },
  );
}

/// generated route for
/// [UsernamePage]
class UsernameRoute extends PageRouteInfo<void> {
  const UsernameRoute({List<PageRouteInfo>? children}) : super(UsernameRoute.name, initialChildren: children);

  static const String name = 'UsernameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UsernamePage();
    },
  );
}

/// generated route for
/// [EmailVerificationPage]
class EmailVerificationRoute extends PageRouteInfo<void> {
  const EmailVerificationRoute({List<PageRouteInfo>? children})
    : super(EmailVerificationRoute.name, initialChildren: children);

  static const String name = 'EmailVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EmailVerificationPage();
    },
  );
}

/// generated route for
/// [MediaDetailPage]
class MediaDetailRoute extends PageRouteInfo<MediaDetailRouteArgs> {
  MediaDetailRoute({
    required String mediaId,
    Media? initialMedia,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MediaDetailRoute.name,
         args: MediaDetailRouteArgs(
           mediaId: mediaId,
           initialMedia: initialMedia,
           key: key,
         ),
         rawPathParams: {'mediaId': mediaId},
         initialChildren: children,
       );

  static const String name = 'MediaDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MediaDetailRouteArgs>(
        orElse: () =>
            MediaDetailRouteArgs(mediaId: pathParams.getString('mediaId')),
      );
      return MediaDetailPage(
        mediaId: args.mediaId,
        initialMedia: args.initialMedia,
        key: args.key,
      );
    },
  );
}

class MediaDetailRouteArgs {
  const MediaDetailRouteArgs({
    required this.mediaId,
    this.initialMedia,
    this.key,
  });

  final String mediaId;

  final Media? initialMedia;

  final Key? key;

  @override
  String toString() {
    return 'MediaDetailRouteArgs{mediaId: $mediaId, initialMedia: $initialMedia, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MediaDetailRouteArgs) return false;
    return mediaId == other.mediaId &&
        initialMedia == other.initialMedia &&
        key == other.key;
  }

  @override
  int get hashCode => mediaId.hashCode ^ initialMedia.hashCode ^ key.hashCode;
}
