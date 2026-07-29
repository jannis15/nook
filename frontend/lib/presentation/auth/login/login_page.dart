import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:nook/domain/auth/use_cases/login_use_case.dart';
import 'package:nook/presentation/auth/login/login_cubit.dart';
import 'package:nook/presentation/auth/login/login_error_localizations.dart';
import 'package:nook/presentation/auth/login/login_presentation_event.dart';
import 'package:nook/presentation/auth/login/login_state.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/app_notification.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(login: LoginUseCase(context.read<AuthRepository>())),
      child: BlocPresentationListener<LoginCubit, LoginPresentationEvent>(
        listener: (context, event) {
          showAppNotification(
            context,
            event.localized(context.l10n),
            type: AppNotificationType.error,
          );
        },
        child: const _LoginView(),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
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
                              autofillHints: const [AutofillHints.email],
                              onChanged: context
                                  .read<LoginCubit>()
                                  .emailChanged,
                              decoration: InputDecoration(
                                labelText: context.l10n.loginEmailLabel,
                                errorText: state.emailError?.localized(
                                  context.l10n,
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Semantics(
                            label: context.l10n.loginPasswordLabel,
                            textField: true,
                            child: TextFormField(
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              onChanged: context
                                  .read<LoginCubit>()
                                  .passwordChanged,
                              onFieldSubmitted: (_) async {
                                final didLogin = await context
                                    .read<LoginCubit>()
                                    .submit();
                                if (didLogin) {
                                  TextInput.finishAutofillContext();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: context.l10n.loginPasswordLabel,
                                errorText: state.passwordError?.localized(
                                  context.l10n,
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: state.isSubmitting
                                ? null
                                : () async {
                                    final didLogin = await context
                                        .read<LoginCubit>()
                                        .submit();
                                    if (didLogin) {
                                      TextInput.finishAutofillContext();
                                    }
                                  },
                            icon: state.isSubmitting
                                ? const SizedBox.shrink()
                                : const _TanukiButtonIcon(),
                            label: state.isSubmitting
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(context.l10n.loginSignInButton),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TanukiButtonIcon extends StatelessWidget {
  const _TanukiButtonIcon();

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color ?? Colors.white;

    return SvgPicture.asset(
      'assets/brand/tanuki-button-icon.svg',
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
