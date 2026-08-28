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
  String get loginShowPasswordButton => 'Show password';

  @override
  String get loginHidePasswordButton => 'Hide password';

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

  @override
  String get mediaAddButton => 'Add media';

  @override
  String get mediaCreatedLabel => 'Created';

  @override
  String get mediaDetailsCloseTooltip => 'Close details';

  @override
  String get mediaDetailsTitle => 'Details';

  @override
  String get mediaEmptyDescription =>
      'Start by adding an image or video from your computer.';

  @override
  String get mediaEmptyTitle => 'No media yet';

  @override
  String get mediaFailureLoad => 'Media could not be loaded.';

  @override
  String get mediaFailureNotFound => 'Media not found.';

  @override
  String get mediaFailureUnknown => 'Something went wrong with your media.';

  @override
  String get mediaFailureUnauthenticated => 'Please sign in again.';

  @override
  String get mediaFailureUnsupported =>
      'Only supported images and videos can be uploaded.';

  @override
  String get mediaInfoMimeTypeLabel => 'MIME type';

  @override
  String get mediaInfoSizeLabel => 'Size';

  @override
  String get mediaInfoTypeLabel => 'Type';

  @override
  String get mediaMuteVideoTooltip => 'Mute video';

  @override
  String get mediaPauseVideoTooltip => 'Pause video';

  @override
  String get mediaPlayVideoTooltip => 'Play video';

  @override
  String get mediaRefreshTooltip => 'Refresh';

  @override
  String get mediaTypeImage => 'Image';

  @override
  String get mediaTypeVideo => 'Video';

  @override
  String get mediaUnmuteVideoTooltip => 'Unmute video';
}
