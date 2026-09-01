import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:rxdart/rxdart.dart';

/// Contract for session authentication operations.
abstract interface class AuthRepository {
  /// The current application identity.
  ValueStream<AppIdentity> get identity;

  /// Authenticates with an email address and password.
  Future<Result<Unit, AuthFailure>> loginWithPassword({required String email, required String password});

  /// Refreshes the current authentication session.
  Future<Result<Unit, AuthFailure>> refreshSession();

  /// Ends the current authenticated session.
  Future<Result<Unit, AuthFailure>> logout();
}
