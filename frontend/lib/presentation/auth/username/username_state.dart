import 'package:nook/domain/auth/use_cases/validate_username_use_case.dart';

/// The current username-completion form state.
class UsernameState {
  /// Default constructor.
  const UsernameState({this.username = '', this.errors = const [], this.isSubmitting = false});

  /// The requested username.
  final String username;

  /// The current username validation errors.
  final List<UsernameValidationError> errors;

  /// Whether completion is in progress.
  final bool isSubmitting;

  /// Whether the username is valid.
  bool get isValid => errors.isEmpty;
}
