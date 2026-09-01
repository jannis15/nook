import 'package:json_annotation/json_annotation.dart';

part 'email_verification_status_response_dto.g.dart';

/// A response containing the current email verification status.
@JsonSerializable(createToJson: false)
class EmailVerificationStatusResponseDto {
  /// Default constructor.
  const EmailVerificationStatusResponseDto({required this.isEmailVerified});

  /// Creates a verification status response from API JSON.
  factory EmailVerificationStatusResponseDto.fromJson(Map<String, Object?> json) =>
      _$EmailVerificationStatusResponseDtoFromJson(json);

  /// Whether the current user's email address is verified.
  final bool isEmailVerified;
}
