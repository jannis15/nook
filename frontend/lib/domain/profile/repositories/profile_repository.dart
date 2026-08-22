import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:rxdart/rxdart.dart';

/// Contract for accessing the current user's profile.
abstract interface class ProfileRepository {
  /// The current user's profile, or `null` when unauthenticated.
  ValueStream<AppProfile?> get ownProfile;
}
