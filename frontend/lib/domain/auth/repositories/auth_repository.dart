import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';

abstract interface class AuthRepository {
  Future<Result<Unit, AuthFailure>> loginWithPassword({
    required String email,
    required String password,
  });
}
