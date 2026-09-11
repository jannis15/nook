import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/use_cases/watch_identity_use_case.dart';
import 'package:nook/domain/profile/use_cases/refresh_own_profile_use_case.dart';
import 'package:nook/domain/profile/use_cases/watch_own_profile_use_case.dart';
import 'package:nook/presentation/auth/loading/auth_loading_cubit.dart';
import 'package:nook/presentation/auth/loading/auth_loading_presentation_event.dart';
import 'package:nook/presentation/auth/loading/auth_loading_state.dart';
import 'package:nook/presentation/auth/widgets/auth_page_scaffold.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';

/// Resolves an authenticated user's profile before entering the application.
@RoutePage()
class AuthLoadingPage extends StatelessWidget {
  /// Default constructor.
  const AuthLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthLoadingCubit(
        refreshOwnProfile: context.read<RefreshOwnProfileUseCase>(),
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
            case EmailVerificationRequired():
              unawaited(context.router.replacePath('/auth/verify-email'));
            case UsernameRequired():
              unawaited(context.router.replacePath('/auth/username'));
          }
        },
        child: const _AuthLoadingView(),
      ),
    );
  }
}

class _AuthLoadingView extends StatelessWidget {
  const _AuthLoadingView();

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      child: BlocBuilder<AuthLoadingCubit, AuthLoadingState>(
        builder: (context, state) {
          return switch (state) {
            AuthLoadingLoading() => const Center(child: CircularProgressIndicator()),
            AuthLoadingError() => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.authLoadingErrorTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.authLoadingErrorDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: context.read<AuthLoadingCubit>().retry,
                  child: Text(context.l10n.authLoadingRetryButton),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}
