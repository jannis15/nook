import 'package:dio/dio.dart';
import 'package:nook/config/app_env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Creates an API client with the current Supabase bearer token.
Dio createApiClient(SupabaseClient supabaseClient) {
  final dio = Dio(BaseOptions(baseUrl: _apiBaseUrl));
  dio.interceptors.add(_AuthInterceptor(supabaseClient));

  return dio;
}

String get _apiBaseUrl {
  return AppEnv.apiBaseUrl.endsWith('/')
      ? AppEnv.apiBaseUrl.substring(0, AppEnv.apiBaseUrl.length - 1)
      : AppEnv.apiBaseUrl;
}

class _AuthInterceptor extends Interceptor {
  const _AuthInterceptor(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = _supabaseClient.auth.currentSession?.accessToken;
    if (accessToken != null) {
      options.headers['authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}
