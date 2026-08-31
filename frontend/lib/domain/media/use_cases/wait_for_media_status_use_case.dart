import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/domain/media/repositories/media_repository.dart';

/// Waits for a media item's processing status through the API.
class WaitForMediaStatusUseCase {
  /// Default constructor.
  const WaitForMediaStatusUseCase(this._repository);

  final MediaRepository _repository;

  /// Waits for the next status update for [id].
  Future<Result<Media, MediaFailure>> call(
    String id, {
    Future<void>? cancellation,
  }) {
    return _repository.waitForMediaStatus(id, cancellation: cancellation);
  }
}
