import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/domain/media/entities/media_page.dart';
import 'package:nook/domain/media/repositories/media_repository.dart';

/// Lists media for the current user.
class ListMediaUseCase {
  /// Default constructor.
  const ListMediaUseCase(this._repository);

  final MediaRepository _repository;

  /// Lists a cursor-paginated page of media for the current user.
  Future<Result<MediaPage, MediaFailure>> call({String? cursor, int limit = 50}) {
    return _repository.listMedia(cursor: cursor, limit: limit);
  }
}
