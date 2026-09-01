import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/data/api/models/error_response_dto.dart';
import 'package:nook/data/media/dtos/media_detail_response_dto.dart';
import 'package:nook/data/media/dtos/media_list_response_dto.dart';
import 'package:nook/data/media/dtos/media_response_dto.dart';
import 'package:nook/data/media/dtos/media_upload_initialization_response_dto.dart';
import 'package:nook/data/media/dtos/media_upload_request_dto.dart';
import 'package:nook/data/media/mappers/media_mapper.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/domain/media/entities/media_page.dart';
import 'package:nook/domain/media/repositories/media_repository.dart';

/// A media repository backed by the Nook API.
class MediaRepositoryImpl implements MediaRepository {
  /// Default constructor.
  const MediaRepositoryImpl(this._dio);

  static final _logger = Logger((MediaRepositoryImpl).toString());

  final Dio _dio;

  @override
  Future<Result<MediaPage, MediaFailure>> listMedia({String? cursor, int limit = 50}) async {
    try {
      final response = await _dio.get<Map<String, Object?>>(
        '/media',
        queryParameters: <String, Object>{'limit': limit, 'cursor': ?cursor},
      );
      final body = response.data;

      if (body == null) {
        return const Error(UnknownMediaFailure());
      }

      final listResponse = MediaListResponseDto.fromJson(body);
      return Success(
        MediaPage(
          media: listResponse.media.map(MediaMapper.toDomain).toList(growable: false),
          nextCursor: listResponse.nextCursor,
        ),
      );
    } on DioException catch (error) {
      _logger.warning('Could not list media.', error, error.stackTrace);
      return Error(_failureFromDioException(error));
    } catch (error, stackTrace) {
      _logger.severe('Could not list media.', error, stackTrace);
      return const Error(UnknownMediaFailure());
    }
  }

  @override
  Future<Result<MediaDetail, MediaFailure>> loadMediaDetail(String id) async {
    try {
      final response = await _dio.get<Map<String, Object?>>('/media/$id');
      final body = response.data;

      if (body == null) {
        return const Error(UnknownMediaFailure());
      }

      return Success(MediaMapper.toDetailDomain(MediaDetailResponseDto.fromJson(body).media));
    } on DioException catch (error) {
      _logger.warning('Could not load media detail.', error, error.stackTrace);
      return Error(_failureFromDioException(error));
    } catch (error, stackTrace) {
      _logger.severe('Could not load media detail.', error, stackTrace);
      return const Error(UnknownMediaFailure());
    }
  }

  @override
  Future<Result<void, MediaFailure>> deleteMedia(String id) async {
    try {
      await _dio.delete<void>('/media/$id');
      return const Success(null);
    } on DioException catch (error) {
      _logger.warning('Could not delete media.', error, error.stackTrace);
      return Error(_failureFromDioException(error));
    } catch (error, stackTrace) {
      _logger.severe('Could not delete media.', error, stackTrace);
      return const Error(UnknownMediaFailure());
    }
  }

  @override
  Future<Result<Media, MediaFailure>> waitForMediaStatus(String id, {Future<void>? cancellation}) async {
    final cancelToken = CancelToken();
    if (cancellation != null) {
      unawaited(cancellation.then((_) => cancelToken.cancel()));
    }

    try {
      final response = await _dio.get<Map<String, Object?>>(
        '/media/$id/status',
        queryParameters: const {'wait': 25},
        cancelToken: cancelToken,
        options: Options(receiveTimeout: const Duration(seconds: 30)),
      );
      final body = response.data;

      if (body == null) {
        return const Error(UnknownMediaFailure());
      }

      return Success(MediaMapper.toDomain(MediaResponseDto.fromJson(body).media));
    } on DioException catch (error) {
      _logger.warning('Could not load media processing status.', error, error.stackTrace);
      return Error(_failureFromDioException(error));
    } catch (error, stackTrace) {
      _logger.severe('Could not load media processing status.', error, stackTrace);
      return const Error(UnknownMediaFailure());
    }
  }

  @override
  Future<Result<Media, MediaFailure>> uploadMedia({
    required String filename,
    required String mimeType,
    required Uint8List bytes,
  }) async {
    try {
      final initializeResponse = await _dio.post<Map<String, Object?>>(
        '/media/uploads',
        data: MediaUploadRequestDto(filename: filename, mimeType: mimeType, fileSize: bytes.length).toJson(),
      );
      final initializeBody = initializeResponse.data;

      if (initializeBody == null) {
        return const Error(UnknownMediaFailure());
      }

      final upload = MediaUploadInitializationResponseDto.fromJson(initializeBody);
      await Dio().put<void>(
        upload.signedUploadUrl,
        data: bytes,
        options: Options(contentType: mimeType, headers: const {'x-upsert': 'false'}),
      );
      final completeResponse = await _dio.post<Map<String, Object?>>('/media/${upload.media.id}/complete');
      final body = completeResponse.data;

      if (body == null) return const Error(UnknownMediaFailure());

      return Success(MediaMapper.toDomain(MediaResponseDto.fromJson(body).media));
    } on DioException catch (error) {
      _logger.warning('Could not upload media.', error, error.stackTrace);
      return Error(_failureFromDioException(error));
    } catch (error, stackTrace) {
      _logger.severe('Could not upload media.', error, stackTrace);
      return const Error(UnknownMediaFailure());
    }
  }

  static MediaFailure _failureFromDioException(DioException error) {
    return switch (error.response?.statusCode) {
      400 => InvalidMediaFailure(_errorMessage(error.response?.data)),
      401 => const UnauthenticatedMediaFailure(),
      404 => const MediaNotFoundFailure(),
      _ => const UnknownMediaFailure(),
    };
  }

  static String? _errorMessage(Object? responseBody) {
    if (responseBody case final Map<String, Object?> body) {
      return ErrorResponseDto.fromJson(body).message;
    }

    return null;
  }
}
