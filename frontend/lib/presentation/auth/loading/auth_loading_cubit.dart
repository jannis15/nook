import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/use_cases/watch_identity_use_case.dart';
import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:nook/domain/profile/entities/profile_failure.dart';
import 'package:nook/domain/profile/use_cases/refresh_own_profile_use_case.dart';
import 'package:nook/domain/profile/use_cases/watch_own_profile_use_case.dart';
import 'package:nook/presentation/auth/loading/auth_loading_presentation_event.dart';
import 'package:nook/presentation/auth/loading/auth_loading_state.dart';

/// Waits for the profile required by an authenticated application session.
class AuthLoadingCubit extends Cubit<AuthLoadingState>
    with BlocPresentationMixin<AuthLoadingState, AuthLoadingPresentationEvent> {
  /// Default constructor.
  AuthLoadingCubit({
    required RefreshOwnProfileUseCase refreshOwnProfile,
    required WatchIdentityUseCase watchIdentity,
    required WatchOwnProfileUseCase watchOwnProfile,
  }) : _watchIdentity = watchIdentity,
       _watchOwnProfile = watchOwnProfile,
       _refreshOwnProfile = refreshOwnProfile,
       super(const AuthLoadingState.loading()) {
    // Presentation listeners are attached after cubit construction.
    scheduleMicrotask(() {
      if (isClosed) {
        return;
      }

      _identitySubscription = _watchIdentity().listen(_identityChanged);
      _profileSubscription = _watchOwnProfile().listen(_profileChanged);
      _profileFailureSubscription = _watchOwnProfile.failures().listen(_profileFailureChanged);
    });
  }

  final WatchIdentityUseCase _watchIdentity;
  final WatchOwnProfileUseCase _watchOwnProfile;
  final RefreshOwnProfileUseCase _refreshOwnProfile;
  bool _hasResolvedProfile = false;
  StreamSubscription<AppIdentity>? _identitySubscription;
  StreamSubscription<AppProfile?>? _profileSubscription;
  StreamSubscription<ProfileFailure?>? _profileFailureSubscription;

  /// Retries loading the authenticated profile.
  Future<void> retry() async {
    emit(const AuthLoadingState.loading());
    await _refreshOwnProfile();
  }

  void _identityChanged(AppIdentity identity) {
    if (identity is AnonymousAppIdentity) {
      emitPresentation(const AuthenticationRequired());
      return;
    }

    if (identity case AuthenticatedAppIdentity(:final isEmailVerified) when !isEmailVerified) {
      emitPresentation(const EmailVerificationRequired());
    }
  }

  void _profileFailureChanged(ProfileFailure? failure) {
    final identity = _watchIdentity().value;
    if (failure != null && identity is AuthenticatedAppIdentity && identity.isEmailVerified) {
      emit(const AuthLoadingState.error());
    }
  }

  void _profileChanged(AppProfile? profile) {
    final identity = _watchIdentity().value;
    if (profile != null && identity is AuthenticatedAppIdentity && identity.isEmailVerified && !_hasResolvedProfile) {
      _hasResolvedProfile = true;
      emitPresentation(profile.isUsernameConfigured ? const AuthenticatedProfileLoaded() : const UsernameRequired());
    }
  }

  @override
  Future<void> close() async {
    await _identitySubscription?.cancel();
    await _profileSubscription?.cancel();
    await _profileFailureSubscription?.cancel();
    return super.close();
  }
}
