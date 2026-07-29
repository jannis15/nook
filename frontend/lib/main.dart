import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:nook/config/app_env.dart';
import 'package:nook/config/app_router.dart';
import 'package:nook/config/app_theme.dart';
import 'package:nook/data/auth/supabase_auth_repository.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/l10n/generated/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  AppEnv.validateRequiredDefines();

  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    publishableKey: AppEnv.supabasePublishableKey,
  );

  final authRepository = SupabaseAuthRepository(Supabase.instance.client);

  runApp(
    RepositoryProvider<AuthRepository>.value(
      value: authRepository,
      child: NookApp(authRepository: authRepository),
    ),
  );
}

class NookApp extends StatefulWidget {
  const NookApp({required this.authRepository, super.key});

  final AuthRepository authRepository;

  @override
  State<NookApp> createState() => _NookAppState();
}

class _NookAppState extends State<NookApp> {
  late final _appRouter = AppRouter(widget.authRepository);
  late final _reevaluateListenable = ReevaluateListenable.stream(
    widget.authRepository.identity,
  );

  @override
  void dispose() {
    _reevaluateListenable.dispose();
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: _appRouter.config(
        reevaluateListenable: _reevaluateListenable,
      ),
    );
  }
}
