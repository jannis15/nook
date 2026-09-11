import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/profile/entities/profile_failure.dart';
import 'package:nook/domain/profile/repositories/profile_repository.dart';

/// Reloads the authenticated user's application profile.
class RefreshOwnProfileUseCase {
  /// Default constructor.
  const RefreshOwnProfileUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  /// Reloads the current profile.
  Future<Result<Unit, ProfileFailure>> call() {
    return _profileRepository.refreshOwnProfile();
  }
}
