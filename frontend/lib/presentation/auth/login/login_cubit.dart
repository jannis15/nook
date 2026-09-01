import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/entities/oauth_provider.dart';
import 'package:nook/domain/auth/use_cases/login_use_case.dart';
import 'package:nook/domain/auth/use_cases/login_with_oauth_use_case.dart';
import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';
import 'package:nook/presentation/auth/login/login_presentation_event.dart';
import 'package:nook/presentation/auth/login/login_state.dart';

/// Manages credentials and submission state for the login form.
class LoginCubit extends Cubit<LoginState> with BlocPresentationMixin<LoginState, LoginPresentationEvent> {
  /// Default constructor.
  LoginCubit({
    required LoginUseCase login,
    required LoginWithOAuthUseCase loginWithOAuth,
    ValidateEmailUseCase validateEmail = const ValidateEmailUseCase(),
  }) : _login = login,
       _loginWithOAuth = loginWithOAuth,
       _validateEmail = validateEmail,
       super(const LoginState());

  final LoginUseCase _login;
  final LoginWithOAuthUseCase _loginWithOAuth;
  final ValidateEmailUseCase _validateEmail;

  /// Updates the email input with [value].
  void emailChanged(String value) {
    final email = value.trim();

    emit(state.copyWith(email: email, emailError: state.emailError == null ? null : _validateEmail(email)));
  }

  /// Starts OAuth authentication with [provider].
  Future<void> loginWithOAuth(AppOAuthProvider provider) async {
    if (state.isSubmitting) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));
    final result = await _loginWithOAuth(provider);
    emit(state.copyWith(isSubmitting: false));
    if (result.isError()) {
      emitPresentation(const LoginSubmissionFailed());
    }
  }

  /// Updates the password input with [value].
  void passwordChanged(String value) {
    emit(state.copyWith(password: value, passwordError: state.passwordError == null ? null : _validatePassword(value)));
  }

  /// Validates and submits the current credentials.
  Future<bool> submit() async {
    if (state.isSubmitting) {
      return false;
    }

    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);
    final nextState = state.copyWith(emailError: emailError, passwordError: passwordError);

    emit(nextState);

    if (!nextState.isValid) {
      return false;
    }

    emit(nextState.copyWith(isSubmitting: true));

    final result = await _login(email: nextState.email, password: nextState.password);
    if (result.isError()) {
      emit(state.copyWith(isSubmitting: false));
      emitPresentation(const LoginSubmissionFailed());
      return false;
    }

    emit(state.copyWith(isSubmitting: false));
    return true;
  }

  LoginPasswordError? _validatePassword(String value) {
    if (value.isEmpty) {
      return LoginPasswordError.empty;
    }

    return null;
  }
}
