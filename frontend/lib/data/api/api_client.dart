import 'dart:async';

import 'package:dio/dio.dart';
import 'package:nook/config/app_env.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Creates an API client with the current Supabase bearer token.
Dio createApiClient(
  SupabaseClient supabaseClient,
  AuthRepository authRepository,
) {
  final dio = Dio(BaseOptions(baseUrl: _apiBaseUrl));
  dio.interceptors.add(_AuthInterceptor(supabaseClient, authRepository));

  return dio;
}

String get _apiBaseUrl {
  return AppEnv.apiBaseUrl.endsWith('/')
      ? AppEnv.apiBaseUrl.substring(0, AppEnv.apiBaseUrl.length - 1)
      : AppEnv.apiBaseUrl;
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._supabaseClient, this._authRepository);

  final SupabaseClient _supabaseClient;
  final AuthRepository _authRepository;
  Future<void>? _logoutFuture;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = _supabaseClient.auth.currentSession?.accessToken;
    if (accessToken != null) {
      options.headers['authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    if (error.response?.statusCode == 401) {
      unawaited(_logoutOnce());
    }

    handler.next(error);
  }

  Future<void> _logoutOnce() {
    final pendingLogout = _logoutFuture;
    if (pendingLogout != null) {
      return pendingLogout;
    }

    final logout = _authRepository.logout();
    _logoutFuture = logout.then<void>((_) {}, onError: (_, _) {});
    return _logoutFuture!.whenComplete(() => _logoutFuture = null);
  }
}
