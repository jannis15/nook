import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

/// A profile returned by the API.
@JsonSerializable(createToJson: false)
class ProfileDto {
  /// Default constructor.
  const ProfileDto({required this.id, required this.email, required this.displayName});

  /// Creates a profile DTO from API JSON.
  factory ProfileDto.fromJson(Map<String, Object?> json) => _$ProfileDtoFromJson(json);

  /// The profile identifier.
  final String id;

  /// The user's email address.
  final String email;

  /// The optional display name.
  final String? displayName;
}
