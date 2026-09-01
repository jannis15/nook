import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';

/// Contract for reading the current email verification status.
abstract interface class EmailVerificationRepository {
  /// Returns whether the current user's email address is verified.
  Future<Result<bool, AuthFailure>> getEmailVerificationStatus();
}
