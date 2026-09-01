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
  String get emailVerificationTitle => 'Verify your email';

  @override
  String get emailVerificationDescription =>
      'We sent you a verification email. Open the link in that email, then refresh this page.';

  @override
  String get emailVerificationRefreshButton => 'Refresh';

  @override
  String get emailVerificationRefreshFailedError =>
      'Could not refresh your verification status. Try again.';

  @override
  String get emailVerificationPendingError =>
      'Your email address is not verified yet.';

  @override
  String get emailVerificationLogoutButton => 'Sign out';

  @override
  String get emailVerificationLogoutFailedError =>
      'Sign out failed. Try again.';

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
  String get loginCreateAccountButton => 'Create account';

  @override
  String get registrationTitle => 'Create your account';

  @override
  String get registrationSubtitle =>
      'Save and organise your personal media library.';

  @override
  String get registrationUsernameLabel => 'Username';

  @override
  String get registrationUsernameRequiredError => 'Enter a username.';

  @override
  String get registrationUsernameTooShortError => 'Use at least 3 characters.';

  @override
  String get registrationUsernameTooLongError =>
      'Use no more than 30 characters.';

  @override
  String get registrationUsernameInvalidCharactersError =>
      'Use only lowercase letters, numbers, and underscores.';

  @override
  String get registrationUsernameUnavailableError =>
      'This username is already taken.';

  @override
  String get registrationEmailLabel => 'Email';

  @override
  String get registrationEmailRequiredError => 'Enter your email.';

  @override
  String get registrationEmailInvalidError => 'Enter a valid email address.';

  @override
  String get registrationPasswordLabel => 'Password';

  @override
  String get registrationPasswordRequiredError => 'Enter a password.';

  @override
  String get registrationPasswordTooShortError => 'Use at least 12 characters.';

  @override
  String get registrationPasswordLowercaseError =>
      'Include a lowercase letter.';

  @override
  String get registrationPasswordUppercaseError =>
      'Include an uppercase letter.';

  @override
  String get registrationPasswordDigitError => 'Include a number.';

  @override
  String get registrationPasswordSpecialCharacterError =>
      'Include an allowed special character.';

  @override
  String get registrationShowPasswordButton => 'Show password';

  @override
  String get registrationHidePasswordButton => 'Hide password';

  @override
  String get registrationSubmissionFailedError =>
      'Could not create your account. Try again.';

  @override
  String get registrationCreateAccountButton => 'Create account';

  @override
  String get registrationSignInButton => 'Already have an account? Sign in';

  @override
  String get homeLogoutButton => 'Sign out';

  @override
  String get homeLogoutFailedError => 'Sign out failed. Try again.';

  @override
  String get mediaAddButton => 'Add media';

  @override
  String get mediaCreatedLabel => 'Created';

  @override
  String get mediaDeleteAction => 'Delete';

  @override
  String get mediaDeleteDialogCancel => 'Cancel';

  @override
  String get mediaDeleteDialogConfirm => 'Delete';

  @override
  String get mediaDeleteDialogMessage =>
      'This will permanently delete this media.';

  @override
  String get mediaDeleteDialogTitle => 'Delete media?';

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
  String get mediaRemoveFailedUploadTooltip => 'Remove failed upload';

  @override
  String get mediaTypeImage => 'Image';

  @override
  String get mediaTypeVideo => 'Video';

  @override
  String get mediaUnmuteVideoTooltip => 'Unmute video';

  @override
  String get mediaViewAction => 'View';
}
