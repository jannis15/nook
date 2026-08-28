import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nook/domain/media/entities/media.dart';

part 'media_library_item.freezed.dart';

/// An item displayed in the media library.
sealed class MediaLibraryItem {
  /// Default constructor.
  const MediaLibraryItem();

  /// The stable item identifier.
  String get id;
}

/// A persisted media item.
class UploadedMediaLibraryItem extends MediaLibraryItem {
  /// Default constructor.
  const UploadedMediaLibraryItem(this.media, {this.localPreviewBytes, this.isDeleting = false});

  /// The persisted media item.
  final Media media;

  /// Original image bytes retained until a server preview is available.
  final Uint8List? localPreviewBytes;

  /// Whether deletion is in progress.
  final bool isDeleting;

  @override
  String get id => media.id;
}

/// The local upload state of a pending media item.
enum PendingMediaStatus {
  /// The file is being uploaded.
  uploading,

  /// The upload failed.
  failed,
}

/// A media item that has not yet completed upload processing.
@freezed
abstract class PendingMediaLibraryItem extends MediaLibraryItem with _$PendingMediaLibraryItem {
  const PendingMediaLibraryItem._();

  /// Default constructor.
  const factory PendingMediaLibraryItem({
    required String id,
    required String filename,
    required String mimeType,
    required int fileSize,
    required DateTime createdAt,
    required MediaType mediaType,
    required Uint8List bytes,
    @Default(PendingMediaStatus.uploading) PendingMediaStatus status,
  }) = _PendingMediaLibraryItem;
}
