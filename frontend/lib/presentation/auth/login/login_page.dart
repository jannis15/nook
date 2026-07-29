import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/presentation/auth/login/login_cubit.dart';
import 'package:nook/presentation/auth/login/login_error_localizations.dart';
import 'package:nook/presentation/auth/login/login_state.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const _LoginView(),
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
                              onChanged: context.read<LoginCubit>().emailChanged,
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
                              onFieldSubmitted: (_) {
                                context.read<LoginCubit>().submit();
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
                          FilledButton(
                            onPressed: context.read<LoginCubit>().submit,
                            child: Text(context.l10n.loginSignInButton),
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
