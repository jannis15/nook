import 'package:nook/domain/media/entities/media.dart';

/// A cursor-paginated page of media.
class MediaPage {
  /// Default constructor.
  const MediaPage({required this.media, required this.nextCursor});

  /// The media returned for this page.
  final List<Media> media;

  /// The cursor for the next page, or `null` when all media has been returned.
  final String? nextCursor;
}
