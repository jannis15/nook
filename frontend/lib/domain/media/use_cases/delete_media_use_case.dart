import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/domain/media/repositories/media_repository.dart';

/// Deletes a media item.
class DeleteMediaUseCase {
  /// Default constructor.
  const DeleteMediaUseCase(this._repository);

  final MediaRepository _repository;

  /// Deletes the media item with [id].
  Future<Result<void, MediaFailure>> call(String id) {
    return _repository.deleteMedia(id);
  }
}
