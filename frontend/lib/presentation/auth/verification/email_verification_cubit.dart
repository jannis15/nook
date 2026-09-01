import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/use_cases/logout_use_case.dart';
import 'package:nook/domain/auth/use_cases/refresh_email_verification_use_case.dart';
import 'package:nook/presentation/auth/verification/email_verification_presentation_event.dart';
import 'package:nook/presentation/auth/verification/email_verification_state.dart';

/// Refreshes the authentication state after email verification.
class EmailVerificationCubit extends Cubit<EmailVerificationState>
    with BlocPresentationMixin<EmailVerificationState, EmailVerificationPresentationEvent> {
  /// Default constructor.
  EmailVerificationCubit({
    required RefreshEmailVerificationUseCase refreshEmailVerification,
    required LogoutUseCase logout,
  }) : _refreshEmailVerification = refreshEmailVerification,
       _logout = logout,
       super(const EmailVerificationState());

  final RefreshEmailVerificationUseCase _refreshEmailVerification;
  final LogoutUseCase _logout;

  /// Refreshes the current authentication session.
  Future<void> refresh() async {
    if (state.isRefreshing || state.isLoggingOut) {
      return;
    }

    emit(const EmailVerificationState(isRefreshing: true));
    final result = await _refreshEmailVerification();
    switch (result) {
      case Success(success: true):
        emit(const EmailVerificationState());
        emitPresentation(const EmailVerificationRefreshed());
      case Success(success: false):
        emit(const EmailVerificationState());
        emitPresentation(const EmailVerificationPending());
      case Error():
        emit(const EmailVerificationState());
        emitPresentation(const EmailVerificationRefreshFailed());
    }
  }

  /// Ends the current session.
  Future<void> logout() async {
    if (state.isRefreshing || state.isLoggingOut) {
      return;
    }

    emit(const EmailVerificationState(isLoggingOut: true));
    final result = await _logout();
    switch (result) {
      case Success():
        emit(const EmailVerificationState());
        emitPresentation(const EmailVerificationLoggedOut());
      case Error():
        emit(const EmailVerificationState());
        emitPresentation(const EmailVerificationLogoutFailed());
    }
  }
}
