import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';
import 'package:nook/domain/auth/use_cases/validate_password_use_case.dart';
import 'package:nook/domain/auth/use_cases/validate_username_use_case.dart';
import 'package:nook/presentation/auth/registration/registration_presentation_event.dart';
import 'package:nook/presentation/l10n/generated/app_localizations.dart';

/// Localised text for registration presentation events.
extension RegistrationPresentationEventLocalizations on RegistrationPresentationEvent {
  /// Returns the localised text for this event.
  String localized(AppLocalizations l10n) {
    return switch (this) {
      EmailVerificationRequired() => l10n.emailVerificationDescription,
      RegistrationUsernameUnavailable() => l10n.registrationUsernameUnavailableError,
      RegistrationSubmissionFailed() => l10n.registrationSubmissionFailedError,
    };
  }
}

/// Localised text for registration email validation errors.
extension RegistrationEmailValidationErrorLocalizations on EmailValidationError {
  /// Returns the localised text for this error.
  String localized(AppLocalizations l10n) {
    return switch (this) {
      EmailValidationError.empty => l10n.registrationEmailRequiredError,
      EmailValidationError.invalid => l10n.registrationEmailInvalidError,
    };
  }
}

/// Localised text for username validation errors.
extension UsernameValidationErrorsLocalizations on List<UsernameValidationError> {
  /// Returns the localised text for every error.
  String localized(AppLocalizations l10n) {
    return map(
      (error) => switch (error) {
        UsernameValidationError.tooShort => l10n.registrationUsernameTooShortError,
        UsernameValidationError.tooLong => l10n.registrationUsernameTooLongError,
        UsernameValidationError.invalidCharacters => l10n.registrationUsernameInvalidCharactersError,
      },
    ).map((error) => '• $error').join('\n');
  }
}

/// Localised text for password validation errors.
extension PasswordValidationErrorsLocalizations on List<PasswordValidationError> {
  /// Returns the localised text for every error.
  String localized(AppLocalizations l10n) {
    return map(
      (error) => switch (error) {
        PasswordValidationError.tooShort => l10n.registrationPasswordTooShortError,
        PasswordValidationError.missingLowercaseLetter => l10n.registrationPasswordLowercaseError,
        PasswordValidationError.missingUppercaseLetter => l10n.registrationPasswordUppercaseError,
        PasswordValidationError.missingDigit => l10n.registrationPasswordDigitError,
        PasswordValidationError.missingSpecialCharacter => l10n.registrationPasswordSpecialCharacterError,
      },
    ).map((error) => '• $error').join('\n');
  }
}
