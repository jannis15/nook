import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';

part 'login_state.freezed.dart';

/// A password validation error.
enum LoginPasswordError {
  /// No password was supplied.
  empty,
}

@freezed
/// The current login form state.
abstract class LoginState with _$LoginState {
  /// Creates a login state.
  const LoginState._();

  /// Default constructor.
  const factory LoginState({
    @Default('') String email,
    @Default('') String password,
    EmailValidationError? emailError,
    LoginPasswordError? passwordError,
    @Default(false) bool isSubmitting,
  }) = _LoginState;

  /// Whether all current form input is valid.
  bool get isValid => emailError == null && passwordError == null;
}
