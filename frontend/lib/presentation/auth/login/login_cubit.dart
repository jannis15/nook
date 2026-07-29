import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';
import 'package:nook/presentation/auth/login/login_presentation_event.dart';
import 'package:nook/presentation/auth/login/login_state.dart';

class LoginCubit extends Cubit<LoginState>
    with BlocPresentationMixin<LoginState, LoginPresentationEvent> {
  LoginCubit({ValidateEmailUseCase validateEmail = const ValidateEmailUseCase()})
    : _validateEmail = validateEmail,
      super(const LoginState());

  final ValidateEmailUseCase _validateEmail;

  void emailChanged(String value) {
    final email = value.trim();
    final emailError = _validateEmail(email);

    emit(
      state.copyWith(
        email: email,
        emailError: emailError,
      ),
    );
  }

  void passwordChanged(String value) {
    final passwordError = _validatePassword(value);

    emit(
      state.copyWith(
        password: value,
        passwordError: passwordError,
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

    if (!nextState.isValid) {
      emitPresentation(
        LoginSubmissionFailed(
          emailError: emailError,
          passwordError: passwordError,
        ),
      );
    }

    return nextState.isValid;
  }

  LoginPasswordError? _validatePassword(String value) {
    if (value.isEmpty) {
      return LoginPasswordError.empty;
    }

    return null;
  }
}
