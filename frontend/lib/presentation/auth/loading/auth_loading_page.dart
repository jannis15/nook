import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/use_cases/watch_identity_use_case.dart';
import 'package:nook/domain/profile/use_cases/watch_own_profile_use_case.dart';
import 'package:nook/presentation/auth/loading/auth_loading_cubit.dart';
import 'package:nook/presentation/auth/loading/auth_loading_presentation_event.dart';
import 'package:nook/presentation/auth/widgets/auth_page_scaffold.dart';

/// Resolves an authenticated user's profile before entering the application.
@RoutePage()
class AuthLoadingPage extends StatelessWidget {
  /// Default constructor.
  const AuthLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthLoadingCubit(
        watchIdentity: context.read<WatchIdentityUseCase>(),
        watchOwnProfile: context.read<WatchOwnProfileUseCase>(),
      ),
      child: BlocPresentationListener<AuthLoadingCubit, AuthLoadingPresentationEvent>(
        listener: (context, event) {
          switch (event) {
            case AuthenticationRequired():
              unawaited(context.router.replacePath('/auth/login'));
            case AuthenticatedProfileLoaded():
              unawaited(context.router.replacePath('/home'));
          }
        },
        child: const AuthPageScaffold(child: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
