import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:nook/domain/profile/repositories/profile_repository.dart';
import 'package:rxdart/rxdart.dart';

/// Provides the current user's profile stream.
class WatchOwnProfileUseCase {
  /// Default constructor.
  const WatchOwnProfileUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  /// Returns the current user's profile stream.
  ValueStream<AppProfile?> call() {
    return _profileRepository.ownProfile;
  }
}
