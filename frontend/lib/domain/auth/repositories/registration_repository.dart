import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/registration_failure.dart';

/// Contract for account registration operations.
abstract interface class RegistrationRepository {
  /// Registers an account with the supplied credentials.
  Future<Result<Unit, RegistrationFailure>> register({
    required String username,
    required String email,
    required String password,
  });
}
