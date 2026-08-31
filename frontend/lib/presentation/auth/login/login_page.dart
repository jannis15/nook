import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/use_cases/login_use_case.dart';
import 'package:nook/presentation/auth/login/login_cubit.dart';
import 'package:nook/presentation/auth/login/login_error_localizations.dart';
import 'package:nook/presentation/auth/login/login_presentation_event.dart';
import 'package:nook/presentation/auth/login/login_state.dart';
import 'package:nook/presentation/auth/login/widgets/tanuki_button_icon.dart';
import 'package:nook/presentation/auth/widgets/auth_page_scaffold.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/app_notification.dart';

@RoutePage()
/// Presents the sign-in form.
class LoginPage extends StatelessWidget {
  /// Default constructor.
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(login: context.read<LoginUseCase>()),
      child: BlocPresentationListener<LoginCubit, LoginPresentationEvent>(
        listener: (context, event) {
          showAppNotification(context, event.localized(context.l10n), type: AppNotificationType.error);
        },
        child: const _LoginView(),
      ),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Form(
            child: AutofillGroup(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.loginTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  Semantics(
                    label: context.l10n.loginEmailLabel,
                    textField: true,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      onChanged: context.read<LoginCubit>().emailChanged,
                      decoration: InputDecoration(
                        labelText: context.l10n.loginEmailLabel,
                        errorText: state.emailError?.localized(context.l10n),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    label: context.l10n.loginPasswordLabel,
                    textField: true,
                    child: TextFormField(
                      obscureText: !_isPasswordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onChanged: context.read<LoginCubit>().passwordChanged,
                      onFieldSubmitted: (_) async {
                        final didLogin = await context.read<LoginCubit>().submit();
                        if (didLogin) {
                          TextInput.finishAutofillContext();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: context.l10n.loginPasswordLabel,
                        errorText: state.passwordError?.localized(context.l10n),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _isPasswordVisible
                              ? context.l10n.loginHidePasswordButton
                              : context.l10n.loginShowPasswordButton,
                          icon: Icon(_isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: state.isSubmitting
                        ? null
                        : () async {
                            final didLogin = await context.read<LoginCubit>().submit();
                            if (didLogin) {
                              TextInput.finishAutofillContext();
                            }
                          },
                    icon: state.isSubmitting ? const SizedBox.shrink() : const TanukiButtonIcon(),
                    label: state.isSubmitting
                        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(context.l10n.loginSignInButton),
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
