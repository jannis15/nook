import 'package:flutter_test/flutter_test.dart';
import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';

void main() {
  const useCase = ValidateEmailUseCase();

  group('ValidateEmailUseCase', () {
    test('returns empty error when email is blank', () {
      expect(useCase(''), EmailValidationError.empty);
      expect(useCase('   '), EmailValidationError.empty);
    });

    test('returns invalid error when email format is invalid', () {
      expect(useCase('user'), EmailValidationError.invalid);
      expect(useCase('user@'), EmailValidationError.invalid);
      expect(useCase('user@example'), EmailValidationError.invalid);
      expect(useCase('@example.com'), EmailValidationError.invalid);
      expect(useCase('user@.com'), EmailValidationError.invalid);
      expect(useCase('user name@example.com'), EmailValidationError.invalid);
      expect(useCase('user@example .com'), EmailValidationError.invalid);
    });

    test('returns null when email format is valid', () {
      expect(useCase('user@example.com'), isNull);
      expect(useCase('first.last@example.co.uk'), isNull);
      expect(useCase(' user@example.com '), isNull);
    });
  });
}
