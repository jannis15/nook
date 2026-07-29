import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';
import 'package:nook/presentation/auth/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({ValidateEmailUseCase validateEmail = const ValidateEmailUseCase()})
    : _validateEmail = validateEmail,
      super(const LoginState());

  final ValidateEmailUseCase _validateEmail;

  void emailChanged(String value) {
    final email = value.trim();

    emit(
      state.copyWith(
        email: email,
        emailError: state.emailError == null ? null : _validateEmail(email),
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        passwordError: state.passwordError == null
            ? null
            : _validatePassword(value),
      ),
    );
  }

  bool submit() {
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);
    final nextState = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
    );

    emit(nextState);

    return nextState.isValid;
  }

  LoginPasswordError? _validatePassword(String value) {
    if (value.isEmpty) {
      return LoginPasswordError.empty;
    }

    return null;
  }
}
