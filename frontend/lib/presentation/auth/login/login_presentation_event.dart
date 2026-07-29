import 'package:nook/domain/auth/use_cases/validate_email_use_case.dart';
import 'package:nook/presentation/auth/login/login_state.dart';

sealed class LoginPresentationEvent {
  const LoginPresentationEvent();
}

final class LoginSubmissionFailed extends LoginPresentationEvent {
  const LoginSubmissionFailed({
    this.emailError,
    this.passwordError,
  });

  final EmailValidationError? emailError;
  final LoginPasswordError? passwordError;
}
