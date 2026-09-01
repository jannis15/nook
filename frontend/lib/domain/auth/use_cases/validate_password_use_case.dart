/// A password validation error.
enum PasswordValidationError {
  /// The password does not meet the minimum length.
  tooShort,

  /// The password has no lowercase letter.
  missingLowercaseLetter,

  /// The password has no uppercase letter.
  missingUppercaseLetter,

  /// The password has no digit.
  missingDigit,

  /// The password has no supported special character.
  missingSpecialCharacter,
}

/// Validates password input for account registration.
class ValidatePasswordUseCase {
  /// Default constructor.
  const ValidatePasswordUseCase();

  /// Returns every unmet password requirement for [value].
  List<PasswordValidationError> call(String value) {
    final errors = <PasswordValidationError>[];
    if (value.length < 12) {
      errors.add(PasswordValidationError.tooShort);
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      errors.add(PasswordValidationError.missingLowercaseLetter);
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      errors.add(PasswordValidationError.missingUppercaseLetter);
    }

    if (!RegExp(r'\d').hasMatch(value)) {
      errors.add(PasswordValidationError.missingDigit);
    }

    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.?]').hasMatch(value)) {
      errors.add(PasswordValidationError.missingSpecialCharacter);
    }

    return errors;
  }
}
