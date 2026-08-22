import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';
import 'package:nook/presentation/auth/login/login_presentation_event.dart';
import 'package:nook/presentation/auth/login/login_state.dart';
import 'package:nook/presentation/l10n/generated/app_localizations.dart';

/// Localised text for login presentation events.
extension LoginPresentationEventLocalizations on LoginPresentationEvent {
  /// Returns the localised text for this event.
  String localized(AppLocalizations l10n) {
    return switch (this) {
      LoginSubmissionFailed() => l10n.loginSubmissionFailedError,
    };
  }
}

/// Localised text for email validation errors.
extension EmailValidationErrorLocalizations on EmailValidationError {
  /// Returns the localised text for this error.
  String localized(AppLocalizations l10n) {
    return switch (this) {
      EmailValidationError.empty => l10n.loginEmailRequiredError,
      EmailValidationError.invalid => l10n.loginEmailInvalidError,
    };
  }
}

/// Localised text for password validation errors.
extension LoginPasswordErrorLocalizations on LoginPasswordError {
  /// Returns the localised text for this error.
  String localized(AppLocalizations l10n) {
    return switch (this) {
      LoginPasswordError.empty => l10n.loginPasswordRequiredError,
    };
  }
}
