import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/use_cases/watch_identity_use_case.dart';
import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:nook/domain/profile/use_cases/watch_own_profile_use_case.dart';
import 'package:nook/presentation/auth/loading/auth_loading_presentation_event.dart';

/// Waits for the profile required by an authenticated application session.
class AuthLoadingCubit extends Cubit<void> with BlocPresentationMixin<void, AuthLoadingPresentationEvent> {
  /// Default constructor.
  AuthLoadingCubit({required WatchIdentityUseCase watchIdentity, required WatchOwnProfileUseCase watchOwnProfile})
    : _watchIdentity = watchIdentity,
      _watchOwnProfile = watchOwnProfile,
      super(null) {
    // Presentation listeners are attached after cubit construction.
    scheduleMicrotask(() {
      if (isClosed) {
        return;
      }

      _identitySubscription = _watchIdentity().listen(_identityChanged);
      _profileSubscription = _watchOwnProfile().listen(_profileChanged);
    });
  }

  final WatchIdentityUseCase _watchIdentity;
  final WatchOwnProfileUseCase _watchOwnProfile;
  bool _hasResolvedProfile = false;
  StreamSubscription<AppIdentity>? _identitySubscription;
  StreamSubscription<AppProfile?>? _profileSubscription;

  void _identityChanged(AppIdentity identity) {
    if (identity is AnonymousAppIdentity) {
      emitPresentation(const AuthenticationRequired());
      return;
    }

    if (identity case AuthenticatedAppIdentity(:final isEmailVerified) when !isEmailVerified) {
      emitPresentation(const EmailVerificationRequired());
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
    return super.close();
  }
}
