import 'package:nook/domain/media/entities/media.dart';

/// Supported upload media types and their constraints.
abstract final class SupportedMediaFileTypes {
  /// Maximum size of image uploads in bytes.
  static const maxImageBytes = 10 * 1024 * 1024;

  /// Maximum size of video uploads in bytes.
  static const maxVideoBytes = 100 * 1024 * 1024;

  /// Extensions accepted by the native file picker.
  static const extensions = ['jpg', 'jpeg', 'png', 'webp', 'gif', 'mp4', 'webm', 'mov', 'm4v', 'avi', 'mkv'];

  /// Finds the MIME type for a filename extension.
  static String? mimeTypeForFilename(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    return switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'mp4' => 'video/mp4',
      'webm' => 'video/webm',
      'mov' => 'video/quicktime',
      'm4v' => 'video/x-m4v',
      'avi' => 'video/x-msvideo',
      'mkv' => 'video/x-matroska',
      _ => null,
    };
  }

  /// Finds the media type for a supported MIME type.
  static MediaType? mediaTypeForMimeType(String mimeType) {
    return switch (mimeType) {
      'image/jpeg' || 'image/png' || 'image/webp' || 'image/gif' => MediaType.image,
      'video/mp4' ||
      'video/webm' ||
      'video/quicktime' ||
      'video/x-m4v' ||
      'video/x-msvideo' ||
      'video/x-matroska' => MediaType.video,
      _ => null,
    };
  }

  /// Validates a supported MIME type and its byte size.
  static String? validationError({required String mimeType, required int byteSize}) {
    final mediaType = mediaTypeForMimeType(mimeType);
    if (mediaType == null) {
      return 'unsupported';
    }

    final maximumBytes = switch (mediaType) {
      MediaType.image => maxImageBytes,
      MediaType.video => maxVideoBytes,
    };
    return byteSize > maximumBytes ? 'too_large' : null;
  }
}
