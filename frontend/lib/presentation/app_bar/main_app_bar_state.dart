import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:nook/domain/profile/use_cases/generate_initials_use_case.dart';

part 'main_app_bar_state.freezed.dart';

const _generateInitials = GenerateInitialsUseCase();

@freezed
/// State displayed by the main app bar.
abstract class MainAppBarState with _$MainAppBarState {
  /// Creates a main app bar state.
  const MainAppBarState._();

  /// Default constructor.
  const factory MainAppBarState({required MainAppBarUser? user, @Default(false) bool isLoggingOut}) = _MainAppBarState;
}

@freezed
/// Presentation model for the signed-in user.
abstract class MainAppBarUser with _$MainAppBarUser {
  /// Creates a main app bar user.
  const MainAppBarUser._();

  /// Default constructor.
  const factory MainAppBarUser({required String id, required String? displayName, required String email}) =
      _MainAppBarUser;

  /// Creates an app bar user from [profile].
  factory MainAppBarUser.fromProfile(AppProfile profile) {
    return MainAppBarUser(id: profile.id, displayName: profile.username, email: profile.email);
  }

  /// The name shown in the app bar.
  String get name => displayName ?? 'User';

  /// The initials derived from [name].
  String get initials => _generateInitials(name);
}
