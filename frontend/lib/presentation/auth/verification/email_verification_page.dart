import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/use_cases/logout_use_case.dart';
import 'package:nook/domain/auth/use_cases/refresh_email_verification_use_case.dart';
import 'package:nook/presentation/auth/verification/email_verification_cubit.dart';
import 'package:nook/presentation/auth/verification/email_verification_presentation_event.dart';
import 'package:nook/presentation/auth/verification/email_verification_state.dart';
import 'package:nook/presentation/auth/widgets/auth_page_scaffold.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/app_notification.dart';

@RoutePage()
/// Prompts a new user to verify their email address.
class EmailVerificationPage extends StatelessWidget {
  /// Default constructor.
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailVerificationCubit(
        refreshEmailVerification: context.read<RefreshEmailVerificationUseCase>(),
        logout: context.read<LogoutUseCase>(),
      ),
      child: BlocPresentationListener<EmailVerificationCubit, EmailVerificationPresentationEvent>(
        listener: (context, event) {
          switch (event) {
            case EmailVerificationRefreshed():
              unawaited(context.router.replacePath('/auth/loading'));
            case EmailVerificationLoggedOut():
              unawaited(context.router.replacePath('/auth/login'));
            case EmailVerificationPending() || EmailVerificationRefreshFailed() || EmailVerificationLogoutFailed():
              showAppNotification(context, switch (event) {
                EmailVerificationPending() => context.l10n.emailVerificationPendingError,
                EmailVerificationRefreshFailed() => context.l10n.emailVerificationRefreshFailedError,
                EmailVerificationLogoutFailed() => context.l10n.emailVerificationLogoutFailedError,
                EmailVerificationRefreshed() || EmailVerificationLoggedOut() => '',
              }, type: AppNotificationType.error);
          }
        },
        child: const _EmailVerificationView(),
      ),
    );
  }
}

class _EmailVerificationView extends StatelessWidget {
  const _EmailVerificationView();

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      child: BlocBuilder<EmailVerificationCubit, EmailVerificationState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.emailVerificationTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.emailVerificationDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: state.isRefreshing || state.isLoggingOut
                    ? null
                    : context.read<EmailVerificationCubit>().refresh,
                child: state.isRefreshing
                    ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(context.l10n.emailVerificationRefreshButton),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: state.isRefreshing || state.isLoggingOut
                    ? null
                    : context.read<EmailVerificationCubit>().logout,
                child: state.isLoggingOut
                    ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(context.l10n.emailVerificationLogoutButton),
              ),
            ],
          );
        },
      ),
    );
  }
}
