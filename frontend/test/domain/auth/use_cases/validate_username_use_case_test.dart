import 'package:flutter_test/flutter_test.dart';
import 'package:nook/domain/auth/use_cases/validate_username_use_case.dart';

void main() {
  group('ValidateUsernameUseCase', () {
    const validateUsername = ValidateUsernameUseCase();

    test('returns every unmet username requirement', () {
      expect(validateUsername('Ja'), const [
        UsernameValidationError.tooShort,
        UsernameValidationError.invalidCharacters,
      ]);
    });

    test('returns no errors for a valid username', () {
      expect(validateUsername('jannis_12'), isEmpty);
    });
  });
}
