import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class AuthRepository {
  ValueStream<AppIdentity> get identity;

  Future<Result<Unit, AuthFailure>> loginWithPassword({
    required String email,
    required String password,
  });

  Future<Result<Unit, AuthFailure>> logout();
}
