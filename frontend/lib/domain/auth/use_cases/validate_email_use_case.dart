enum EmailValidationError { empty, invalid }

class ValidateEmailUseCase {
  const ValidateEmailUseCase();

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
