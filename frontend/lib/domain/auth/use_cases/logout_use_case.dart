import 'dart:async';

import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';

/// Ends the authenticated session and confirms the identity update.
class LogoutUseCase {
  /// Default constructor.
  const LogoutUseCase(this._authRepository);

  static const _identityUpdateTimeout = Duration(seconds: 3);

  final AuthRepository _authRepository;

  /// Ends the current session.
  Future<Result<Unit, AuthFailure>> call() async {
    final result = await _authRepository.logout();
    if (result.isError()) {
      return result;
    }

    if (!_authRepository.identity.value.isAuthenticated) {
      return result;
    }

    try {
      await _authRepository.identity
          .firstWhere((identity) => identity is AnonymousAppIdentity)
          .timeout(_identityUpdateTimeout);
      return result;
    } catch (_) {
      return const Error(UnknownAuthFailure());
    }
  }
}
