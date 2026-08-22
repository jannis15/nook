import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/use_cases/logout_use_case.dart';
import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:nook/domain/profile/use_cases/watch_own_profile_use_case.dart';
import 'package:nook/presentation/app_bar/main_app_bar_presentation_event.dart';
import 'package:nook/presentation/app_bar/main_app_bar_state.dart';

/// Manages profile and sign-out state for the top app bar.
class MainAppBarCubit extends Cubit<MainAppBarState>
    with BlocPresentationMixin<MainAppBarState, MainAppBarPresentationEvent> {
  /// Default constructor.
  MainAppBarCubit({required WatchOwnProfileUseCase watchOwnProfile, required LogoutUseCase logout})
    : _logout = logout,
      super(MainAppBarState(user: _userFromProfile(watchOwnProfile().value))) {
    _profileSubscription = watchOwnProfile().listen(_profileChanged);
  }

  final LogoutUseCase _logout;
  late final StreamSubscription<AppProfile?> _profileSubscription;

  void _profileChanged(AppProfile? profile) {
    emit(state.copyWith(user: _userFromProfile(profile)));
  }

  /// Ends the current session.
  Future<void> logout() async {
    if (state.isLoggingOut) {
      return;
    }

    emit(state.copyWith(isLoggingOut: true));

    final result = await _logout();

    emit(state.copyWith(isLoggingOut: false));

    if (result.isError()) {
      emitPresentation(const MainAppBarLogoutFailed());
    }
  }

  @override
  Future<void> close() async {
    await _profileSubscription.cancel();
    return super.close();
  }

  static MainAppBarUser? _userFromProfile(AppProfile? profile) {
    if (profile == null) {
      return null;
    }

    return MainAppBarUser.fromProfile(profile);
  }
}
