/// An email address validation error.
enum EmailValidationError {
  /// No email address was supplied.
  empty,

  /// The supplied value is not a valid email address.
  invalid,
}

/// Validates email address input for authentication forms.
class ValidateEmailUseCase {
  /// Default constructor.
  const ValidateEmailUseCase();

  /// Returns an error for [value], or `null` when it is valid.
  EmailValidationError? call(String value) {
    final email = value.trim();

    if (email.isEmpty) {
      return EmailValidationError.empty;
    }

    // Basic UI validation: text before @, text before ., text after ., and no whitespace.
    final isValidEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!isValidEmail) {
      return EmailValidationError.invalid;
    }

    return null;
  }
}
