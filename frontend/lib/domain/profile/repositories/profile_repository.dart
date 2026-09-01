import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:nook/domain/profile/entities/profile_failure.dart';
import 'package:rxdart/rxdart.dart';

/// Contract for accessing the current user's profile.
abstract interface class ProfileRepository {
  /// The current user's profile, or `null` when unauthenticated.
  ValueStream<AppProfile?> get ownProfile;

  /// Sets the username for the authenticated user's profile.
  Future<Result<Unit, ProfileFailure>> completeUsername(String username);
}
