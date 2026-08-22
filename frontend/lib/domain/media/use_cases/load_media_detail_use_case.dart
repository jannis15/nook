import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/domain/media/repositories/media_repository.dart';

/// Loads a media item by identifier.
class LoadMediaDetailUseCase {
  /// Default constructor.
  const LoadMediaDetailUseCase(this._repository);

  final MediaRepository _repository;

  /// Loads a media item by identifier.
  Future<Result<MediaDetail, MediaFailure>> call(String id) {
    return _repository.loadMediaDetail(id);
  }
}
