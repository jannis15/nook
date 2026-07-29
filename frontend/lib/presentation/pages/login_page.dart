import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nook/presentation/l10n/generated/app_localizations.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.loginTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.loginEmailLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.loginPasswordLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: null,
                    child: Text(l10n.loginSignInButton),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
