import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/profile/entities/profile_failure.dart';
import 'package:nook/domain/profile/repositories/profile_repository.dart';

/// Sets the username required to complete an OAuth-created profile.
class CompleteUsernameUseCase {
  /// Default constructor.
  const CompleteUsernameUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  /// Sets [username] for the current profile.
  Future<Result<Unit, ProfileFailure>> call(String username) {
    return _profileRepository.completeUsername(username);
  }
}
