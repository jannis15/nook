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
/// [MediaDetailPage]
class MediaDetailRoute extends PageRouteInfo<MediaDetailRouteArgs> {
  MediaDetailRoute({
    required String mediaId,
    Media? initialMedia,
    List<PageRouteInfo>? children,
  }) : super(
         MediaDetailRoute.name,
         args: MediaDetailRouteArgs(
           mediaId: mediaId,
           initialMedia: initialMedia,
         ),
         rawPathParams: {'mediaId': mediaId},
         initialChildren: children,
       );

  static const String name = 'MediaDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MediaDetailRouteArgs>();
      return MediaDetailPage(
        mediaId: args.mediaId,
        initialMedia: args.initialMedia,
      );
    },
  );
}

/// Arguments for [MediaDetailRoute].
class MediaDetailRouteArgs {
  /// Default constructor.
  const MediaDetailRouteArgs({required this.mediaId, this.initialMedia});

  /// Identifier from the media detail route path.
  final String mediaId;

  /// Media already available from the originating library view.
  final Media? initialMedia;

  @override
  String toString() =>
      'MediaDetailRouteArgs{mediaId: $mediaId, initialMedia: $initialMedia}';
}
