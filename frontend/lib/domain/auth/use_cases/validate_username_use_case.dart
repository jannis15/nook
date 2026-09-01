/// A username validation error.
enum UsernameValidationError {
  /// The username is shorter than the minimum length.
  tooShort,

  /// The username exceeds the maximum length.
  tooLong,

  /// The username has unsupported characters.
  invalidCharacters,
}

/// Validates username input for account registration.
class ValidateUsernameUseCase {
  /// Default constructor.
  const ValidateUsernameUseCase();

  /// Returns every unmet username requirement for [value].
  List<UsernameValidationError> call(String value) {
    final errors = <UsernameValidationError>[];
    if (value.length < 3) {
      errors.add(UsernameValidationError.tooShort);
    }

    if (value.length > 30) {
      errors.add(UsernameValidationError.tooLong);
    }

    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(value)) {
      errors.add(UsernameValidationError.invalidCharacters);
    }

    return errors;
  }
}
