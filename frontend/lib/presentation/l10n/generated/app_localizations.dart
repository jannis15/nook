import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Nook'**
  String get appTitle;

  /// No description provided for @emailVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get emailVerificationTitle;

  /// No description provided for @emailVerificationDescription.
  ///
  /// In en, this message translates to:
  /// **'We sent you a verification email. Open the link in that email, then refresh this page.'**
  String get emailVerificationDescription;

  /// No description provided for @emailVerificationRefreshButton.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get emailVerificationRefreshButton;

  /// No description provided for @emailVerificationRefreshFailedError.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh your verification status. Try again.'**
  String get emailVerificationRefreshFailedError;

  /// No description provided for @emailVerificationPendingError.
  ///
  /// In en, this message translates to:
  /// **'Your email address is not verified yet.'**
  String get emailVerificationPendingError;

  /// No description provided for @emailVerificationLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get emailVerificationLogoutButton;

  /// No description provided for @emailVerificationLogoutFailedError.
  ///
  /// In en, this message translates to:
  /// **'Sign out failed. Try again.'**
  String get emailVerificationLogoutFailedError;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Nook'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your personal media library.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter your email.'**
  String get loginEmailRequiredError;

  /// No description provided for @loginEmailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get loginEmailInvalidError;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginShowPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPasswordButton;

  /// No description provided for @loginHidePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePasswordButton;

  /// No description provided for @loginPasswordRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get loginPasswordRequiredError;

  /// No description provided for @loginSubmissionFailedError.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed. Check your email and password.'**
  String get loginSubmissionFailedError;

  /// No description provided for @loginSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignInButton;

  /// No description provided for @loginCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccountButton;

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registrationTitle;

  /// No description provided for @registrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save and organise your personal media library.'**
  String get registrationSubtitle;

  /// No description provided for @registrationUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get registrationUsernameLabel;

  /// No description provided for @registrationUsernameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter a username.'**
  String get registrationUsernameRequiredError;

  /// No description provided for @registrationUsernameTooShortError.
  ///
  /// In en, this message translates to:
  /// **'Use at least 3 characters.'**
  String get registrationUsernameTooShortError;

  /// No description provided for @registrationUsernameTooLongError.
  ///
  /// In en, this message translates to:
  /// **'Use no more than 30 characters.'**
  String get registrationUsernameTooLongError;

  /// No description provided for @registrationUsernameInvalidCharactersError.
  ///
  /// In en, this message translates to:
  /// **'Use only lowercase letters, numbers, and underscores.'**
  String get registrationUsernameInvalidCharactersError;

  /// No description provided for @registrationUsernameUnavailableError.
  ///
  /// In en, this message translates to:
  /// **'This username is already taken.'**
  String get registrationUsernameUnavailableError;

  /// No description provided for @registrationEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registrationEmailLabel;

  /// No description provided for @registrationEmailRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter your email.'**
  String get registrationEmailRequiredError;

  /// No description provided for @registrationEmailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get registrationEmailInvalidError;

  /// No description provided for @registrationPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registrationPasswordLabel;

  /// No description provided for @registrationPasswordRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter a password.'**
  String get registrationPasswordRequiredError;

  /// No description provided for @registrationPasswordTooShortError.
  ///
  /// In en, this message translates to:
  /// **'Use at least 12 characters.'**
  String get registrationPasswordTooShortError;

  /// No description provided for @registrationPasswordLowercaseError.
  ///
  /// In en, this message translates to:
  /// **'Include a lowercase letter.'**
  String get registrationPasswordLowercaseError;

  /// No description provided for @registrationPasswordUppercaseError.
  ///
  /// In en, this message translates to:
  /// **'Include an uppercase letter.'**
  String get registrationPasswordUppercaseError;

  /// No description provided for @registrationPasswordDigitError.
  ///
  /// In en, this message translates to:
  /// **'Include a number.'**
  String get registrationPasswordDigitError;

  /// No description provided for @registrationPasswordSpecialCharacterError.
  ///
  /// In en, this message translates to:
  /// **'Include an allowed special character.'**
  String get registrationPasswordSpecialCharacterError;

  /// No description provided for @registrationShowPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get registrationShowPasswordButton;

  /// No description provided for @registrationHidePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get registrationHidePasswordButton;

  /// No description provided for @registrationSubmissionFailedError.
  ///
  /// In en, this message translates to:
  /// **'Could not create your account. Try again.'**
  String get registrationSubmissionFailedError;

  /// No description provided for @registrationCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registrationCreateAccountButton;

  /// No description provided for @registrationSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get registrationSignInButton;

  /// No description provided for @homeLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get homeLogoutButton;

  /// No description provided for @homeLogoutFailedError.
  ///
  /// In en, this message translates to:
  /// **'Sign out failed. Try again.'**
  String get homeLogoutFailedError;

  /// No description provided for @mediaAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add media'**
  String get mediaAddButton;

  /// No description provided for @mediaCreatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get mediaCreatedLabel;

  /// No description provided for @mediaDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get mediaDeleteAction;

  /// No description provided for @mediaDeleteDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get mediaDeleteDialogCancel;

  /// No description provided for @mediaDeleteDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get mediaDeleteDialogConfirm;

  /// No description provided for @mediaDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete this media.'**
  String get mediaDeleteDialogMessage;

  /// No description provided for @mediaDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete media?'**
  String get mediaDeleteDialogTitle;

  /// No description provided for @mediaDetailsCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close details'**
  String get mediaDetailsCloseTooltip;

  /// No description provided for @mediaDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get mediaDetailsTitle;

  /// No description provided for @mediaEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Start by adding an image or video from your computer.'**
  String get mediaEmptyDescription;

  /// No description provided for @mediaEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No media yet'**
  String get mediaEmptyTitle;

  /// No description provided for @mediaFailureLoad.
  ///
  /// In en, this message translates to:
  /// **'Media could not be loaded.'**
  String get mediaFailureLoad;

  /// No description provided for @mediaFailureNotFound.
  ///
  /// In en, this message translates to:
  /// **'Media not found.'**
  String get mediaFailureNotFound;

  /// No description provided for @mediaFailureUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong with your media.'**
  String get mediaFailureUnknown;

  /// No description provided for @mediaFailureUnauthenticated.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again.'**
  String get mediaFailureUnauthenticated;

  /// No description provided for @mediaFailureUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Only supported images and videos can be uploaded.'**
  String get mediaFailureUnsupported;

  /// No description provided for @mediaInfoMimeTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'MIME type'**
  String get mediaInfoMimeTypeLabel;

  /// No description provided for @mediaInfoSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get mediaInfoSizeLabel;

  /// No description provided for @mediaInfoTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get mediaInfoTypeLabel;

  /// No description provided for @mediaMuteVideoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Mute video'**
  String get mediaMuteVideoTooltip;

  /// No description provided for @mediaPauseVideoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Pause video'**
  String get mediaPauseVideoTooltip;

  /// No description provided for @mediaPlayVideoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Play video'**
  String get mediaPlayVideoTooltip;

  /// No description provided for @mediaRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get mediaRefreshTooltip;

  /// No description provided for @mediaRemoveFailedUploadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove failed upload'**
  String get mediaRemoveFailedUploadTooltip;

  /// No description provided for @mediaTypeImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get mediaTypeImage;

  /// No description provided for @mediaTypeVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get mediaTypeVideo;

  /// No description provided for @mediaUnmuteVideoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Unmute video'**
  String get mediaUnmuteVideoTooltip;

  /// No description provided for @mediaViewAction.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get mediaViewAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
