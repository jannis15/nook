import 'package:flutter_test/flutter_test.dart';
import 'package:nook/domain/auth/use_cases/validate_password_use_case.dart';

void main() {
  group('ValidatePasswordUseCase', () {
    const validatePassword = ValidatePasswordUseCase();

    test('returns every unmet password requirement', () {
      expect(validatePassword('short'), const [
        PasswordValidationError.tooShort,
        PasswordValidationError.missingUppercaseLetter,
        PasswordValidationError.missingDigit,
        PasswordValidationError.missingSpecialCharacter,
      ]);
    });

    test('returns no errors for a password that meets every requirement', () {
      expect(validatePassword('SecurePassword1!'), isEmpty);
    });
  });
}
