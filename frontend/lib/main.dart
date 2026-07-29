import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/config/app_env.dart';
import 'package:nook/config/app_router.dart';
import 'package:nook/config/app_theme.dart';
import 'package:nook/data/auth/supabase_auth_repository.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/l10n/generated/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _requiredEnv = AppEnv.requiredDefines;

Future<void> main() async {
  _requiredEnv;
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    publishableKey: AppEnv.supabasePublishableKey,
  );

  runApp(
    RepositoryProvider<AuthRepository>(
      create: (_) => SupabaseAuthRepository(Supabase.instance.client),
      child: const NookApp(),
    ),
  );
}

final _appRouter = AppRouter();

class NookApp extends StatelessWidget {
  const NookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: _appRouter.config(),
    );
  }
}
