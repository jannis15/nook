import 'dart:typed_data';

import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/domain/media/entities/media_page.dart';

/// Provides media for the current user.
abstract interface class MediaRepository {
  /// Lists a cursor-paginated page of the current user's media.
  Future<Result<MediaPage, MediaFailure>> listMedia({
    String? cursor,
    int limit = 50,
  });

  /// Loads a media item by its identifier.
  Future<Result<MediaDetail, MediaFailure>> loadMediaDetail(String id);

  /// Deletes a media item by its identifier.
  Future<Result<void, MediaFailure>> deleteMedia(String id);

  /// Waits for the next media processing status update.
  Future<Result<Media, MediaFailure>> waitForMediaStatus(
    String id, {
    Future<void>? cancellation,
  });

  /// Uploads a media file.
  Future<Result<Media, MediaFailure>> uploadMedia({
    required String filename,
    required String mimeType,
    required Uint8List bytes,
  });
}
