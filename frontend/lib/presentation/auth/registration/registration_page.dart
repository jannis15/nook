import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/use_cases/register_use_case.dart';
import 'package:nook/presentation/auth/login/widgets/tanuki_button_icon.dart';
import 'package:nook/presentation/auth/registration/registration_cubit.dart';
import 'package:nook/presentation/auth/registration/registration_error_localizations.dart';
import 'package:nook/presentation/auth/registration/registration_presentation_event.dart';
import 'package:nook/presentation/auth/registration/registration_state.dart';
import 'package:nook/presentation/auth/widgets/auth_page_scaffold.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/app_notification.dart';

@RoutePage()
/// Presents the account registration form.
class RegistrationPage extends StatelessWidget {
  /// Default constructor.
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationCubit(register: context.read<RegisterUseCase>()),
      child: BlocPresentationListener<RegistrationCubit, RegistrationPresentationEvent>(
        listener: (context, event) {
          switch (event) {
            case EmailVerificationRequired():
              TextInput.finishAutofillContext();
              unawaited(context.router.replacePath('/auth/verify-email'));
            case RegistrationUsernameUnavailable() || RegistrationSubmissionFailed():
              showAppNotification(context, event.localized(context.l10n), type: AppNotificationType.error);
          }
        },
        child: const _RegistrationView(),
      ),
    );
  }
}

class _RegistrationView extends StatefulWidget {
  const _RegistrationView();

  @override
  State<_RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<_RegistrationView> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      child: BlocBuilder<RegistrationCubit, RegistrationState>(
        builder: (context, state) {
          return Form(
            child: AutofillGroup(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.registrationTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.registrationSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newUsername],
                    onChanged: context.read<RegistrationCubit>().usernameChanged,
                    decoration: InputDecoration(
                      labelText: context.l10n.registrationUsernameLabel,
                      errorText: state.usernameErrors.isEmpty ? null : state.usernameErrors.localized(context.l10n),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    onChanged: context.read<RegistrationCubit>().emailChanged,
                    decoration: InputDecoration(
                      labelText: context.l10n.registrationEmailLabel,
                      errorText: state.emailError?.localized(context.l10n),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: !_isPasswordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    onChanged: context.read<RegistrationCubit>().passwordChanged,
                    onFieldSubmitted: (_) => context.read<RegistrationCubit>().submit(),
                    decoration: InputDecoration(
                      labelText: context.l10n.registrationPasswordLabel,
                      errorText: state.passwordErrors.isEmpty ? null : state.passwordErrors.localized(context.l10n),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: _isPasswordVisible
                            ? context.l10n.registrationHidePasswordButton
                            : context.l10n.registrationShowPasswordButton,
                        icon: Icon(_isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: state.isSubmitting ? null : context.read<RegistrationCubit>().submit,
                    icon: state.isSubmitting ? const SizedBox.shrink() : const TanukiButtonIcon(),
                    label: state.isSubmitting
                        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(context.l10n.registrationCreateAccountButton),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.router.replacePath('/auth/login'),
                    child: Text(context.l10n.registrationSignInButton),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
