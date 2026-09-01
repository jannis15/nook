import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nook/domain/auth/entities/oauth_provider.dart';

/// Displays the official mark for an OAuth provider.
class OAuthProviderIcon extends StatelessWidget {
  /// Default constructor.
  const OAuthProviderIcon({required this.provider, super.key});

  /// The provider represented by this icon.
  final AppOAuthProvider provider;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      switch (provider) {
        AppOAuthProvider.google => 'assets/brand/google-logo.svg',
        AppOAuthProvider.github => 'assets/brand/github-mark.svg',
      },
      width: 20,
      height: 20,
    );
  }
}
