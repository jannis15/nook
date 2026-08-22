import 'package:json_annotation/json_annotation.dart';

part 'pending_media_dto.g.dart';

/// The pending media item returned when an upload is initialised.
@JsonSerializable(createToJson: false)
class PendingMediaDto {
  /// Default constructor.
  const PendingMediaDto({required this.id});

  /// Creates a pending media DTO from API JSON.
  factory PendingMediaDto.fromJson(Map<String, Object?> json) => _$PendingMediaDtoFromJson(json);

  /// The media identifier.
  final String id;
}
