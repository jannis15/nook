import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';
import 'package:nook/domain/auth/use_cases/validate_password_use_case.dart';
import 'package:nook/domain/auth/use_cases/validate_username_use_case.dart';

/// The current registration form state.
class RegistrationState {
  /// Default constructor.
  const RegistrationState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.usernameErrors = const [],
    this.emailError,
    this.passwordErrors = const [],
    this.isSubmitting = false,
  });

  /// The requested username.
  final String username;

  /// The account email address.
  final String email;

  /// The account password.
  final String password;

  /// The current username validation errors.
  final List<UsernameValidationError> usernameErrors;

  /// The current email validation error.
  final EmailValidationError? emailError;

  /// The current password validation error.
  final List<PasswordValidationError> passwordErrors;

  /// Whether the registration request is in progress.
  final bool isSubmitting;

  /// Whether all current form input is valid.
  bool get isValid => usernameErrors.isEmpty && emailError == null && passwordErrors.isEmpty;
}
