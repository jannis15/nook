import 'package:flutter_test/flutter_test.dart';
import 'package:nook/domain/profile/use_cases/generate_initials_use_case.dart';

void main() {
  const useCase = GenerateInitialsUseCase();

  group('GenerateInitialsUseCase', () {
    test('returns fallback for blank values', () {
      expect(useCase(''), '?');
      expect(useCase('   '), '?');
    });

    test('returns first initial for one word', () {
      expect(useCase('Jannis'), 'J');
      expect(useCase(' jannis '), 'J');
    });

    test('returns initials for the first two words', () {
      expect(useCase('Jannis Nook'), 'JN');
      expect(useCase('Jannis van Nook'), 'JV');
      expect(useCase('jannis   nook'), 'JN');
    });
  });
}
