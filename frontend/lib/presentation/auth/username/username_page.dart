import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/profile/use_cases/complete_username_use_case.dart';
import 'package:nook/presentation/auth/registration/registration_error_localizations.dart';
import 'package:nook/presentation/auth/username/username_cubit.dart';
import 'package:nook/presentation/auth/username/username_presentation_event.dart';
import 'package:nook/presentation/auth/username/username_state.dart';
import 'package:nook/presentation/auth/widgets/auth_page_scaffold.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/app_notification.dart';

@RoutePage()
/// Prompts OAuth users to choose their required username.
class UsernamePage extends StatelessWidget {
  /// Default constructor.
  const UsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsernameCubit(completeUsername: context.read<CompleteUsernameUseCase>()),
      child: BlocPresentationListener<UsernameCubit, UsernamePresentationEvent>(
        listener: (context, event) {
          switch (event) {
            case UsernameCompleted():
              unawaited(context.router.replacePath('/home'));
            case UsernameUnavailable():
              showAppNotification(context, context.l10n.usernameUnavailableError, type: AppNotificationType.error);
            case UsernameCompletionFailed():
              showAppNotification(context, context.l10n.usernameCompletionFailedError, type: AppNotificationType.error);
          }
        },
        child: const _UsernameView(),
      ),
    );
  }
}

class _UsernameView extends StatelessWidget {
  const _UsernameView();

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      child: BlocBuilder<UsernameCubit, UsernameState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.usernameTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.usernameSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              TextFormField(
                textInputAction: TextInputAction.done,
                onChanged: context.read<UsernameCubit>().usernameChanged,
                onFieldSubmitted: (_) => context.read<UsernameCubit>().submit(),
                decoration: InputDecoration(
                  labelText: context.l10n.usernameLabel,
                  errorText: state.errors.isEmpty ? null : state.errors.localized(context.l10n),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: state.isSubmitting ? null : context.read<UsernameCubit>().submit,
                child: state.isSubmitting
                    ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(context.l10n.usernameContinueButton),
              ),
            ],
          );
        },
      ),
    );
  }
}
