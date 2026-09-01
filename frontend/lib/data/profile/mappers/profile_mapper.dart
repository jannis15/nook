import 'package:nook/data/profile/dtos/profile_dto.dart';
import 'package:nook/domain/profile/entities/app_profile.dart';

/// Maps profile API DTOs to domain entities.
abstract final class ProfileMapper {
  /// Maps an API profile DTO to a domain profile entity.
  static AppProfile toDomain(ProfileDto profile) {
    return AppProfile(
      id: profile.id,
      email: profile.email,
      username: profile.username,
      isUsernameConfigured: profile.isUsernameConfigured,
    );
  }
}
