import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  const SupabaseAuthRepository(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<Result<Unit, AuthFailure>> loginWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return Success.unit();
    } on AuthException catch (error) {
      if (error.statusCode == '400') {
        return const Error(InvalidCredentialsAuthFailure());
      }

      return const Error(UnknownAuthFailure());
    } catch (_) {
      return const Error(UnknownAuthFailure());
    }
  }
}
