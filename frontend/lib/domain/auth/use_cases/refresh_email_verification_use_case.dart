import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:nook/domain/auth/repositories/email_verification_repository.dart';

/// Refreshes and reads the current email verification status.
class RefreshEmailVerificationUseCase {
  /// Default constructor.
  const RefreshEmailVerificationUseCase(
    this._emailVerificationRepository,
    this._authRepository,
  );

  final EmailVerificationRepository _emailVerificationRepository;
  final AuthRepository _authRepository;

  /// Returns whether the email address has been verified.
  Future<Result<bool, AuthFailure>> call() async {
    final refreshResult = await _authRepository.refreshSession();
    switch (refreshResult) {
      case Error(:final error):
        return Error(error);
      case Success():
    }

    final status = await _emailVerificationRepository
        .getEmailVerificationStatus();
    switch (status) {
      case Success(:final success):
        if (!success) {
          return Success(false);
        }

        return Success(true);
      case Error(:final error):
        return Error(error);
    }
  }
}
