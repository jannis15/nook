import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/data/profile/dtos/profile_response_dto.dart';
import 'package:nook/data/profile/mappers/profile_mapper.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:nook/domain/profile/entities/profile_failure.dart';
import 'package:nook/domain/profile/repositories/profile_repository.dart';
import 'package:rxdart/rxdart.dart';

/// A profile repository backed by the Nook API.
class ProfileRepositoryImpl implements ProfileRepository {
  static final _logger = Logger((ProfileRepositoryImpl).toString());

  /// Default constructor.
  ProfileRepositoryImpl(this._dio, {required AuthRepository authRepository}) {
    _authSubscription = authRepository.identity.skip(1).listen(_identityChanged);
    _identityChanged(authRepository.identity.value);
  }

  final Dio _dio;
  final _ownProfile = BehaviorSubject<AppProfile?>.seeded(null);
  late final StreamSubscription<AppIdentity> _authSubscription;

  @override
  ValueStream<AppProfile?> get ownProfile => _ownProfile.stream;

  void _identityChanged(AppIdentity identity) {
    if (identity is AnonymousAppIdentity) {
      _ownProfile.add(null);
      return;
    }

    _ownProfile.add(null);
    unawaited(_refreshOwnProfile());
  }

  Future<void> _refreshOwnProfile() async {
    final result = await _getOwnProfile();
    switch (result) {
      case Success(:final success):
        _ownProfile.add(success);
      case Error():
        break;
    }
  }

  Future<Result<AppProfile, ProfileFailure>> _getOwnProfile() async {
    try {
      final response = await _dio.get<Map<String, Object?>>('/profiles/me');
      final body = response.data;

      if (body == null) {
        return const Error(UnknownProfileFailure());
      }

      return Success(ProfileMapper.toDomain(ProfileResponseDto.fromJson(body).profile));
    } on DioException catch (error) {
      _logger.warning('Could not load the current profile.', error, error.stackTrace);
      if (error.response?.statusCode == 401) {
        return const Error(UnauthenticatedProfileFailure());
      }

      return const Error(UnknownProfileFailure());
    } catch (error, stackTrace) {
      _logger.severe('Could not load the current profile.', error, stackTrace);
      return const Error(UnknownProfileFailure());
    }
  }

  /// Releases the repository's stream resources.
  Future<void> dispose() async {
    await _authSubscription.cancel();
    await _ownProfile.close();
  }
}
