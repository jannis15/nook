import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:nook/domain/auth/entities/oauth_provider.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';

/// Starts OAuth authentication with an external provider.
class LoginWithOAuthUseCase {
  /// Default constructor.
  const LoginWithOAuthUseCase(this._authRepository);

  final AuthRepository _authRepository;

  /// Starts authentication with [provider].
  Future<Result<Unit, AuthFailure>> call(AppOAuthProvider provider) {
    return _authRepository.loginWithOAuth(provider);
  }
}
