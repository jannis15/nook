/// The type of media stored in the library.
enum MediaType {
  /// An image file.
  image,

  /// A video file.
  video,
}

/// The processing state of stored media.
enum MediaStatus {
  /// The media is awaiting processing.
  pending,

  /// The media is being processed.
  processing,

  /// The media is ready to use.
  ready,

  /// Processing the media failed.
  failed,
}

/// A media item available to the current user.
class Media {
  /// Default constructor.
  const Media({
    required this.id,
    required this.originalFilename,
    required this.mediaType,
    required this.mimeType,
    required this.fileSize,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.previewUrl,
    this.blurHash,
    this.title,
    this.description,
  });

  /// The stable media identifier.
  final String id;

  /// The filename supplied during upload.
  final String originalFilename;

  /// The kind of media.
  final MediaType mediaType;

  /// The file's MIME type.
  final String mimeType;

  /// The file size in bytes.
  final int fileSize;

  /// The current media processing status.
  final MediaStatus status;

  /// When the media record was created.
  final DateTime createdAt;

  /// When the media record was last updated.
  final DateTime updatedAt;

  /// The signed URL for the derived preview image, when ready.
  final String? previewUrl;

  /// The BlurHash generated from the derived preview image, when ready.
  final String? blurHash;

  /// The user-defined title, when available.
  final String? title;

  /// The user-defined description, when available.
  final String? description;

  /// The user-defined title when present, otherwise the original filename.
  String get displayName {
    final trimmedTitle = title?.trim();
    return trimmedTitle == null || trimmedTitle.isEmpty ? originalFilename : trimmedTitle;
  }
}

/// A media item with a signed URL to its original file.
class MediaDetail extends Media {
  /// Default constructor.
  const MediaDetail({
    required super.id,
    required super.originalFilename,
    required super.mediaType,
    required super.mimeType,
    required super.fileSize,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required this.mediaUrl,
    super.previewUrl,
    super.blurHash,
    super.title,
    super.description,
  });

  /// The signed URL to the original media file.
  final String mediaUrl;
}
