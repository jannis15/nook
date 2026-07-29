import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:nook/domain/profile/repositories/profile_repository.dart';
import 'package:rxdart/rxdart.dart';

class WatchOwnProfileUseCase {
  const WatchOwnProfileUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  ValueStream<AppProfile?> call() {
    return _profileRepository.ownProfile;
  }
}
