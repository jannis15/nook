import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';

/// Authenticates a user with email and password credentials.
class LoginUseCase {
  /// Default constructor.
  const LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  /// Performs authentication with the supplied credentials.
  Future<Result<Unit, AuthFailure>> call({required String email, required String password}) {
    return _authRepository.loginWithPassword(email: email, password: password);
  }
}
