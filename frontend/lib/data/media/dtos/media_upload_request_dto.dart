import 'package:json_annotation/json_annotation.dart';

part 'media_upload_request_dto.g.dart';

/// A request that initialises a direct media upload.
@JsonSerializable(createFactory: false)
class MediaUploadRequestDto {
  /// Default constructor.
  const MediaUploadRequestDto({required this.filename, required this.mimeType, required this.fileSize});

  /// Converts this request to its API representation.
  Map<String, dynamic> toJson() => _$MediaUploadRequestDtoToJson(this);

  /// The original filename.
  final String filename;

  /// The file MIME type.
  final String mimeType;

  /// The file size in bytes.
  final int fileSize;
}
