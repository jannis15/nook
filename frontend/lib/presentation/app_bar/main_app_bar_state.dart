import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:nook/domain/profile/use_cases/generate_initials_use_case.dart';

part 'main_app_bar_state.freezed.dart';

const _generateInitials = GenerateInitialsUseCase();

@freezed
abstract class MainAppBarState with _$MainAppBarState {
  const MainAppBarState._();

  const factory MainAppBarState({
    required MainAppBarUser? user,
    @Default(false) bool isLoggingOut,
  }) = _MainAppBarState;
}

@freezed
abstract class MainAppBarUser with _$MainAppBarUser {
  const MainAppBarUser._();

  const factory MainAppBarUser({
    required String id,
    required String? displayName,
    required String? email,
  }) = _MainAppBarUser;

  factory MainAppBarUser.fromProfile(AppProfile profile) {
    return MainAppBarUser(
      id: profile.id,
      displayName: profile.displayName,
      email: profile.email,
    );
  }

  String get name => displayName ?? 'User';

  String get initials => _generateInitials(name);
}
