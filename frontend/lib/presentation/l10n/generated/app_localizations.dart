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

  /// No description provided for @mediaInfoContentHashLabel.
  ///
  /// In en, this message translates to:
  /// **'Content hash'**
  String get mediaInfoContentHashLabel;

  /// No description provided for @mediaInfoDimensionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get mediaInfoDimensionsLabel;

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

  /// No description provided for @mediaInfoStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get mediaInfoStatusLabel;

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

  /// No description provided for @mediaUnmuteVideoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Unmute video'**
  String get mediaUnmuteVideoTooltip;
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
