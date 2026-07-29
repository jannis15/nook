import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';

part 'login_state.freezed.dart';

enum LoginPasswordError { empty }

@freezed
abstract class LoginState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    @Default('') String email,
    @Default('') String password,
    EmailValidationError? emailError,
    LoginPasswordError? passwordError,
  }) = _LoginState;

  bool get isValid => emailError == null && passwordError == null;
}
