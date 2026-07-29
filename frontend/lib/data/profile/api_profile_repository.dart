import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/config/app_env.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:nook/domain/profile/entities/profile_failure.dart';
import 'package:nook/domain/profile/repositories/profile_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository(
    this._supabaseClient, {
    required AuthRepository authRepository,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client() {
    _authSubscription = authRepository.identity
        .skip(1)
        .listen(_identityChanged);
    _identityChanged(authRepository.identity.value);
  }

  final SupabaseClient _supabaseClient;
  final http.Client _httpClient;
  final _ownProfile = BehaviorSubject<AppProfile?>.seeded(null);
  late final StreamSubscription<AppIdentity> _authSubscription;

  @override
  ValueStream<AppProfile?> get ownProfile => _ownProfile.stream;

  void _identityChanged(AppIdentity identity) {
    if (identity is AnonymousAppIdentity) {
      _ownProfile.add(null);
      return;
    }

    final authenticatedIdentity = identity as AuthenticatedAppIdentity;
    _ownProfile.add(
      AppProfile(
        id: authenticatedIdentity.id,
        displayName: null,
        email: authenticatedIdentity.email,
      ),
    );
    unawaited(_refreshOwnProfile());
  }

  Future<void> _refreshOwnProfile() async {
    final result = await _getOwnProfile();
    result.when(_ownProfile.add, (error) {});
  }

  Future<Result<AppProfile, ProfileFailure>> _getOwnProfile() async {
    final accessToken = _supabaseClient.auth.currentSession?.accessToken;
    if (accessToken == null) {
      return const Error(UnauthenticatedProfileFailure());
    }

    try {
      final response = await _httpClient.get(
        _apiUri('/profiles/me'),
        headers: {'authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 401) {
        return const Error(UnauthenticatedProfileFailure());
      }

      if (response.statusCode != 200) {
        return const Error(UnknownProfileFailure());
      }

      final body = jsonDecode(response.body) as Map<String, Object?>;
      final profile = body['profile'] as Map<String, Object?>;

      return Success(
        AppProfile(
          id: profile['id'] as String,
          displayName: profile['display_name'] as String?,
          email: profile['email'] as String?,
        ),
      );
    } catch (_) {
      return const Error(UnknownProfileFailure());
    }
  }

  Future<void> dispose() async {
    await _authSubscription.cancel();
    await _ownProfile.close();
    _httpClient.close();
  }

  static Uri _apiUri(String path) {
    final baseUrl = AppEnv.apiBaseUrl.endsWith('/')
        ? AppEnv.apiBaseUrl.substring(0, AppEnv.apiBaseUrl.length - 1)
        : AppEnv.apiBaseUrl;

    return Uri.parse('$baseUrl$path');
  }
}
