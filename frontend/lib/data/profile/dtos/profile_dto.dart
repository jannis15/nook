import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

/// A profile returned by the API.
@JsonSerializable(createToJson: false)
class ProfileDto {
  /// Default constructor.
  const ProfileDto({required this.id, required this.email, required this.username, required this.isUsernameConfigured});

  /// Creates a profile DTO from API JSON.
  factory ProfileDto.fromJson(Map<String, Object?> json) => _$ProfileDtoFromJson(json);

  /// The profile identifier.
  final String id;

  /// The user's email address.
  final String email;

  /// The user's username.
  final String username;

  /// Whether the user has selected a username.
  final bool isUsernameConfigured;
}
