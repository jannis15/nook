/// Build-time environment values required by the application.
class AppEnv {
  /// Prevents instantiation.
  const AppEnv._();

  /// Verifies that all required Dart defines are present.
  static void validateRequiredDefines() {
    final missing = [
      if (!const bool.hasEnvironment('API_BASE_URL')) 'API_BASE_URL',
      if (!const bool.hasEnvironment('SUPABASE_URL')) 'SUPABASE_URL',
      if (!const bool.hasEnvironment('SUPABASE_PUBLISHABLE_KEY')) 'SUPABASE_PUBLISHABLE_KEY',
    ];

    if (missing.isNotEmpty) {
      throw StateError('Missing required dart defines: ${missing.join(', ')}');
    }
  }

  /// The API base URL supplied at build time.
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// The Supabase project URL supplied at build time.
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// The Supabase publishable key supplied at build time.
  static const supabasePublishableKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
}
