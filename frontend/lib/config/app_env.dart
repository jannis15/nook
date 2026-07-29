class AppEnv {
  const AppEnv._();

  static void validateRequiredDefines() {
    final missing = [
      if (!const bool.hasEnvironment('API_BASE_URL')) 'API_BASE_URL',
      if (!const bool.hasEnvironment('SUPABASE_URL')) 'SUPABASE_URL',
      if (!const bool.hasEnvironment('SUPABASE_PUBLISHABLE_KEY'))
        'SUPABASE_PUBLISHABLE_KEY',
    ];

    if (missing.isNotEmpty) {
      throw StateError('Missing required dart defines: ${missing.join(', ')}');
    }
  }

  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
}
