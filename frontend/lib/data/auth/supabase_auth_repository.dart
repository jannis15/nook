import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._supabaseClient)
    : _currentIdentity = _identityFromUser(
        _supabaseClient.auth.currentSession?.user,
      );

  final SupabaseClient _supabaseClient;
  AppIdentity _currentIdentity;

  @override
  AppIdentity get currentIdentity => _currentIdentity;

  @override
  late final Stream<AppIdentity> identity = _supabaseClient
      .auth
      .onAuthStateChange
      .map((event) {
        final identity = _identityFromUser(event.session?.user);
        _currentIdentity = identity;
        return identity;
      })
      .handleError((Object _, StackTrace _) {});

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

  static AppIdentity _identityFromUser(User? user) {
    if (user == null) {
      return const AnonymousAppIdentity();
    }

    return AuthenticatedAppIdentity(id: user.id, email: user.email);
  }
}
