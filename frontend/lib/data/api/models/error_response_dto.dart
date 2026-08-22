import 'package:json_annotation/json_annotation.dart';

part 'error_response_dto.g.dart';

@JsonSerializable(createToJson: false)
/// An API error response.
class ErrorResponseDto {
  /// Default constructor.
  const ErrorResponseDto({required this.code, required this.message});

  /// Creates an error response from API JSON.
  factory ErrorResponseDto.fromJson(Map<String, Object?> json) => _$ErrorResponseDtoFromJson(json);

  /// The API-defined error code.
  final String code;

  /// The human-readable error message.
  final String message;
}
