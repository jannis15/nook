import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';

abstract interface class AuthRepository {
  AppIdentity get currentIdentity;

  Stream<AppIdentity> get identity;

  Future<Result<Unit, AuthFailure>> loginWithPassword({
    required String email,
    required String password,
  });
}
