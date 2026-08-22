import 'package:nook/domain/media/entities/media_failure.dart';

/// A one-off effect requested by [MediaDetailCubit].
sealed class MediaDetailPresentationEvent {
  /// Default constructor.
  const MediaDetailPresentationEvent();
}

/// Notifies the UI that loading media detail failed.
final class MediaDetailLoadFailed extends MediaDetailPresentationEvent {
  /// Default constructor.
  const MediaDetailLoadFailed(this.failure);

  /// The reported failure.
  final MediaFailure failure;
}
