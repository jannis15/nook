import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:nook/config/app_env.dart';
import 'package:nook/config/app_router.dart';
import 'package:nook/config/app_theme.dart';
import 'package:nook/data/api/api_client.dart';
import 'package:nook/data/auth/auth_repository_supabase.dart';
import 'package:nook/data/auth/repositories/email_verification_repository_impl.dart';
import 'package:nook/data/auth/repositories/registration_repository_impl.dart';
import 'package:nook/data/media/repositories/media_repository_impl.dart';
import 'package:nook/data/profile/repositories/profile_repository_impl.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:nook/domain/auth/repositories/email_verification_repository.dart';
import 'package:nook/domain/auth/repositories/registration_repository.dart';
import 'package:nook/domain/auth/use_cases/login_use_case.dart';
import 'package:nook/domain/auth/use_cases/login_with_oauth_use_case.dart';
import 'package:nook/domain/auth/use_cases/logout_use_case.dart';
import 'package:nook/domain/auth/use_cases/refresh_email_verification_use_case.dart';
import 'package:nook/domain/auth/use_cases/register_use_case.dart';
import 'package:nook/domain/auth/use_cases/watch_identity_use_case.dart';
import 'package:nook/domain/media/repositories/media_repository.dart';
import 'package:nook/domain/media/use_cases/delete_media_use_case.dart';
import 'package:nook/domain/media/use_cases/list_media_use_case.dart';
import 'package:nook/domain/media/use_cases/load_media_detail_use_case.dart';
import 'package:nook/domain/media/use_cases/upload_media_use_case.dart';
import 'package:nook/domain/media/use_cases/wait_for_media_status_use_case.dart';
import 'package:nook/domain/profile/repositories/profile_repository.dart';
import 'package:nook/domain/profile/use_cases/complete_username_use_case.dart';
import 'package:nook/domain/profile/use_cases/watch_own_profile_use_case.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/l10n/generated/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  AppEnv.validateRequiredDefines();

  await Supabase.initialize(url: AppEnv.supabaseUrl, publishableKey: AppEnv.supabasePublishableKey);

  final supabaseClient = Supabase.instance.client;
  final authRepository = AuthRepositorySupabase(supabaseClient);
  final apiClient = createApiClient(supabaseClient, authRepository);
  final registrationRepository = RegistrationRepositoryImpl(apiClient);
  final emailVerificationRepository = EmailVerificationRepositoryImpl(apiClient);
  final profileRepository = ProfileRepositoryImpl(apiClient, authRepository: authRepository);
  final mediaRepository = MediaRepositoryImpl(apiClient);
  final watchIdentity = WatchIdentityUseCase(authRepository);
  final watchOwnProfile = WatchOwnProfileUseCase(profileRepository);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<RegistrationRepository>.value(value: registrationRepository),
        RepositoryProvider<EmailVerificationRepository>.value(value: emailVerificationRepository),
        RepositoryProvider<ProfileRepository>.value(value: profileRepository),
        RepositoryProvider<MediaRepository>.value(value: mediaRepository),
        RepositoryProvider<WatchIdentityUseCase>.value(value: watchIdentity),
        RepositoryProvider<WatchOwnProfileUseCase>.value(value: watchOwnProfile),
        RepositoryProvider<CompleteUsernameUseCase>.value(value: CompleteUsernameUseCase(profileRepository)),
        RepositoryProvider<DeleteMediaUseCase>.value(value: DeleteMediaUseCase(mediaRepository)),
        RepositoryProvider<ListMediaUseCase>.value(value: ListMediaUseCase(mediaRepository)),
        RepositoryProvider<LoadMediaDetailUseCase>.value(value: LoadMediaDetailUseCase(mediaRepository)),
        RepositoryProvider<UploadMediaUseCase>.value(value: UploadMediaUseCase(mediaRepository)),
        RepositoryProvider<WaitForMediaStatusUseCase>.value(value: WaitForMediaStatusUseCase(mediaRepository)),
        RepositoryProvider<LoginUseCase>.value(value: LoginUseCase(authRepository)),
        RepositoryProvider<LoginWithOAuthUseCase>.value(value: LoginWithOAuthUseCase(authRepository)),
        RepositoryProvider<LogoutUseCase>.value(value: LogoutUseCase(authRepository)),
        RepositoryProvider<RegisterUseCase>.value(value: RegisterUseCase(registrationRepository)),
        RepositoryProvider<RefreshEmailVerificationUseCase>.value(
          value: RefreshEmailVerificationUseCase(emailVerificationRepository, authRepository),
        ),
      ],
      child: NookApp(watchIdentity: watchIdentity, watchOwnProfile: watchOwnProfile),
    ),
  );
}

/// The root application widget.
class NookApp extends StatefulWidget {
  /// Default constructor.
  const NookApp({required this.watchIdentity, required this.watchOwnProfile, super.key});

  /// Provides the identity stream used to re-evaluate routes.
  final WatchIdentityUseCase watchIdentity;

  /// Provides the profile stream used to gate authenticated routes.
  final WatchOwnProfileUseCase watchOwnProfile;

  @override
  State<NookApp> createState() => _NookAppState();
}

class _NookAppState extends State<NookApp> {
  late final _appRouter = AppRouter(widget.watchIdentity, widget.watchOwnProfile);
  late final _reevaluateListenable = ReevaluateListenable.stream(widget.watchIdentity());

  @override
  void dispose() {
    _reevaluateListenable.dispose();
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: _appRouter.config(reevaluateListenable: _reevaluateListenable),
      ),
    );
  }
}
