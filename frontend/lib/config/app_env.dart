// ignore_for_file: const_eval_throws_exception

class AppEnv {
  const AppEnv._();

  static const requiredDefines = [
    _RequiredDefine('API_BASE_URL', bool.hasEnvironment('API_BASE_URL')),
    _RequiredDefine('SUPABASE_URL', bool.hasEnvironment('SUPABASE_URL')),
    _RequiredDefine(
      'SUPABASE_PUBLISHABLE_KEY',
      bool.hasEnvironment('SUPABASE_PUBLISHABLE_KEY'),
    ),
  ];

  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
}

class _RequiredDefine {
  const _RequiredDefine(this.name, this.exists)
    : assert(exists, 'Missing required dart define');

  final String name;
  final bool exists;
}
