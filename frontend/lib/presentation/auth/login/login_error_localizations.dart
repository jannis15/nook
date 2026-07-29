import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';
import 'package:nook/presentation/auth/login/login_presentation_event.dart';
import 'package:nook/presentation/auth/login/login_state.dart';
import 'package:nook/presentation/l10n/generated/app_localizations.dart';

extension LoginPresentationEventLocalizations on LoginPresentationEvent {
  String localized(AppLocalizations l10n) {
    return switch (this) {
      LoginSubmissionFailed(:final emailError, :final passwordError) =>
        emailError?.localized(l10n) ??
            passwordError?.localized(l10n) ??
            l10n.loginSubmissionFailedError,
    };
  }
}

extension EmailValidationErrorLocalizations on EmailValidationError {
  String localized(AppLocalizations l10n) {
    return switch (this) {
      EmailValidationError.empty => l10n.loginEmailRequiredError,
      EmailValidationError.invalid => l10n.loginEmailInvalidError,
    };
  }
}

extension LoginPasswordErrorLocalizations on LoginPasswordError {
  String localized(AppLocalizations l10n) {
    return switch (this) {
      LoginPasswordError.empty => l10n.loginPasswordRequiredError,
    };
  }
}
