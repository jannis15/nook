import 'dart:typed_data';

import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/domain/media/entities/supported_media_file_types.dart';
import 'package:nook/domain/media/repositories/media_repository.dart';

/// Validates and uploads a media file.
class UploadMediaUseCase {
  /// Default constructor.
  const UploadMediaUseCase(this._repository);

  final MediaRepository _repository;

  /// Validates and uploads a media file.
  Future<Result<Media, MediaFailure>> call({
    required String filename,
    required String mimeType,
    required Uint8List bytes,
  }) {
    final validationError = SupportedMediaFileTypes.validationError(mimeType: mimeType, byteSize: bytes.length);
    if (validationError != null) {
      return Future.value(Error(InvalidMediaFailure(validationError)));
    }

    return _repository.uploadMedia(filename: filename, mimeType: mimeType, bytes: bytes);
  }
}
