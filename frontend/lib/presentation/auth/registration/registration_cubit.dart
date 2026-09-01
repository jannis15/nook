import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/registration_failure.dart';
import 'package:nook/domain/auth/use_cases/register_use_case.dart';
import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';
import 'package:nook/domain/auth/use_cases/validate_password_use_case.dart';
import 'package:nook/domain/auth/use_cases/validate_username_use_case.dart';
import 'package:nook/presentation/auth/registration/registration_presentation_event.dart';
import 'package:nook/presentation/auth/registration/registration_state.dart';

/// Manages account details and submission state for the registration form.
class RegistrationCubit extends Cubit<RegistrationState>
    with BlocPresentationMixin<RegistrationState, RegistrationPresentationEvent> {
  /// Default constructor.
  RegistrationCubit({
    required RegisterUseCase register,
    ValidateEmailUseCase validateEmail = const ValidateEmailUseCase(),
    ValidatePasswordUseCase validatePassword = const ValidatePasswordUseCase(),
    ValidateUsernameUseCase validateUsername = const ValidateUsernameUseCase(),
  }) : _register = register,
       _validateEmail = validateEmail,
       _validatePassword = validatePassword,
       _validateUsername = validateUsername,
       super(const RegistrationState());

  final RegisterUseCase _register;
  final ValidateEmailUseCase _validateEmail;
  final ValidatePasswordUseCase _validatePassword;
  final ValidateUsernameUseCase _validateUsername;

  /// Updates the username input with [value].
  void usernameChanged(String value) {
    final username = value.trim();
    emit(
      _stateWith(
        username: username,
        usernameErrors: state.usernameErrors.isEmpty ? const [] : _validateUsername(username),
        updateUsernameErrors: true,
      ),
    );
  }

  /// Updates the email input with [value].
  void emailChanged(String value) {
    final email = value.trim();
    emit(
      _stateWith(
        email: email,
        emailError: state.emailError == null ? null : _validateEmail(email),
        updateEmailError: true,
      ),
    );
  }

  /// Updates the password input with [value].
  void passwordChanged(String value) {
    emit(
      _stateWith(
        password: value,
        passwordErrors: state.passwordErrors.isEmpty ? const [] : _validatePassword(value),
        updatePasswordErrors: true,
      ),
    );
  }

  /// Validates and submits the current account details.
  Future<void> submit() async {
    if (state.isSubmitting) {
      return;
    }

    final usernameErrors = _validateUsername(state.username);
    final emailError = _validateEmail(state.email);
    final passwordErrors = _validatePassword(state.password);
    final nextState = _stateWith(
      usernameErrors: usernameErrors,
      emailError: emailError,
      passwordErrors: passwordErrors,
      updateEmailError: true,
      updatePasswordErrors: true,
      updateUsernameErrors: true,
    );
    emit(nextState);

    if (!nextState.isValid) {
      return;
    }

    emit(_stateWith(isSubmitting: true));
    final result = await _register(username: nextState.username, email: nextState.email, password: nextState.password);
    switch (result) {
      case Success():
        emit(_stateWith(isSubmitting: false));
        emitPresentation(const EmailVerificationRequired());
      case Error(:final error):
        emit(_stateWith(isSubmitting: false));
        switch (error) {
          case UsernameUnavailableRegistrationFailure():
            emitPresentation(const RegistrationUsernameUnavailable());
          case UnknownRegistrationFailure():
            emitPresentation(const RegistrationSubmissionFailed());
        }
    }
  }

  RegistrationState _stateWith({
    String? username,
    String? email,
    String? password,
    List<UsernameValidationError>? usernameErrors,
    bool updateUsernameErrors = false,
    EmailValidationError? emailError,
    bool updateEmailError = false,
    List<PasswordValidationError>? passwordErrors,
    bool updatePasswordErrors = false,
    bool? isSubmitting,
  }) {
    return RegistrationState(
      username: username ?? state.username,
      email: email ?? state.email,
      password: password ?? state.password,
      usernameErrors: updateUsernameErrors ? usernameErrors ?? const [] : state.usernameErrors,
      emailError: updateEmailError ? emailError : state.emailError,
      passwordErrors: updatePasswordErrors ? passwordErrors ?? const [] : state.passwordErrors,
      isSubmitting: isSubmitting ?? state.isSubmitting,
    );
  }
}
