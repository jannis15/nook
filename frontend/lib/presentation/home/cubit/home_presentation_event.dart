import 'package:nook/domain/media/entities/media_failure.dart';

/// A one-off effect requested by [HomeCubit].
sealed class HomePresentationEvent {
  /// Default constructor.
  const HomePresentationEvent();
}

/// Notifies the UI that a media operation failed.
final class HomeMediaOperationFailed extends HomePresentationEvent {
  /// Default constructor.
  const HomeMediaOperationFailed(this.failure);

  /// The failure returned by the media operation.
  final MediaFailure failure;
}
