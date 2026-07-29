// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nook';

  @override
  String get loginTitle => 'Nook';

  @override
  String get loginSubtitle => 'Sign in to your personal media library.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailRequiredError => 'Enter your email.';

  @override
  String get loginEmailInvalidError => 'Enter a valid email address.';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequiredError => 'Enter your password.';

  @override
  String get loginSubmissionFailedError =>
      'Sign in failed. Check your email and password.';

  @override
  String get loginSignInButton => 'Sign in';

  @override
  String get homeLogoutButton => 'Sign out';

  @override
  String get homeLogoutFailedError => 'Sign out failed. Try again.';
}
