import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Result<Unit, AuthFailure>> call({
    required String email,
    required String password,
  }) {
    return _authRepository.loginWithPassword(email: email, password: password);
  }
}
