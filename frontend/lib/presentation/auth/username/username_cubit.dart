import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/use_cases/validate_username_use_case.dart';
import 'package:nook/domain/profile/entities/profile_failure.dart';
import 'package:nook/domain/profile/use_cases/complete_username_use_case.dart';
import 'package:nook/presentation/auth/username/username_presentation_event.dart';
import 'package:nook/presentation/auth/username/username_state.dart';

/// Manages username completion for OAuth-created profiles.
class UsernameCubit extends Cubit<UsernameState> with BlocPresentationMixin<UsernameState, UsernamePresentationEvent> {
  /// Default constructor.
  UsernameCubit({
    required CompleteUsernameUseCase completeUsername,
    ValidateUsernameUseCase validateUsername = const ValidateUsernameUseCase(),
  }) : _completeUsername = completeUsername,
       _validateUsername = validateUsername,
       super(const UsernameState());

  final CompleteUsernameUseCase _completeUsername;
  final ValidateUsernameUseCase _validateUsername;

  /// Updates the requested username.
  void usernameChanged(String value) {
    final username = value.trim();
    emit(
      UsernameState(
        username: username,
        errors: state.errors.isEmpty ? const [] : _validateUsername(username),
        isSubmitting: state.isSubmitting,
      ),
    );
  }

  /// Validates and completes the current profile username.
  Future<void> submit() async {
    if (state.isSubmitting) {
      return;
    }

    final errors = _validateUsername(state.username);
    if (errors.isNotEmpty) {
      emit(UsernameState(username: state.username, errors: errors));
      return;
    }

    emit(UsernameState(username: state.username, isSubmitting: true));
    final result = await _completeUsername(state.username);
    switch (result) {
      case Success():
        emit(UsernameState(username: state.username));
        emitPresentation(const UsernameCompleted());
      case Error(:final error):
        emit(UsernameState(username: state.username));
        switch (error) {
          case UsernameUnavailableProfileFailure():
            emitPresentation(const UsernameUnavailable());
          case UnauthenticatedProfileFailure() || UnknownProfileFailure():
            emitPresentation(const UsernameCompletionFailed());
        }
    }
  }
}
