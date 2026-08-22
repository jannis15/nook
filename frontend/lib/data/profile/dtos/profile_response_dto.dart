import 'package:json_annotation/json_annotation.dart';
import 'package:nook/data/profile/dtos/profile_dto.dart';

part 'profile_response_dto.g.dart';

/// A response containing the current profile.
@JsonSerializable(createToJson: false)
class ProfileResponseDto {
  /// Default constructor.
  const ProfileResponseDto({required this.profile});

  /// Creates a profile response from API JSON.
  factory ProfileResponseDto.fromJson(Map<String, Object?> json) => _$ProfileResponseDtoFromJson(json);

  /// The current profile.
  final ProfileDto profile;
}
