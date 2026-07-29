import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/presentation/auth/login/login_cubit.dart';
import 'package:nook/presentation/auth/login/login_error_localizations.dart';
import 'package:nook/presentation/auth/login/login_presentation_event.dart';
import 'package:nook/presentation/auth/login/login_state.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocPresentationListener<LoginCubit, LoginPresentationEvent>(
        listener: (context, event) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(event.localized(context.l10n))),
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
                  return Column(
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
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: context.read<LoginCubit>().emailChanged,
                        decoration: InputDecoration(
                          labelText: context.l10n.loginEmailLabel,
                          errorText: state.emailError?.localized(context.l10n),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        obscureText: true,
                        onChanged: context.read<LoginCubit>().passwordChanged,
                        decoration: InputDecoration(
                          labelText: context.l10n.loginPasswordLabel,
                          errorText: state.passwordError?.localized(context.l10n),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: context.read<LoginCubit>().submit,
                        child: Text(context.l10n.loginSignInButton),
                      ),
                    ],
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
