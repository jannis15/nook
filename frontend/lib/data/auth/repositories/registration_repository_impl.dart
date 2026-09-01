import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/data/api/models/error_response_dto.dart';
import 'package:nook/data/auth/dtos/registration_request_dto.dart';
import 'package:nook/domain/auth/entities/registration_failure.dart';
import 'package:nook/domain/auth/repositories/registration_repository.dart';

/// An API-backed account registration repository.
class RegistrationRepositoryImpl implements RegistrationRepository {
  /// Default constructor.
  const RegistrationRepositoryImpl(this._dio);

  static final _logger = Logger((RegistrationRepositoryImpl).toString());

  final Dio _dio;

  @override
  Future<Result<Unit, RegistrationFailure>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post<void>(
        '/profiles',
        data: RegistrationRequestDto(username: username, email: email, password: password).toJson(),
      );
      return Success.unit();
    } on DioException catch (error) {
      _logger.warning('Could not register an account.', error, error.stackTrace);
      return Error(_failureFromDioException(error));
    } catch (error, stackTrace) {
      _logger.severe('Could not register an account.', error, stackTrace);
      return const Error(UnknownRegistrationFailure());
    }
  }

  static RegistrationFailure _failureFromDioException(DioException error) {
    final responseBody = error.response?.data;
    if (error.response?.statusCode != 409) {
      return const UnknownRegistrationFailure();
    }

    if (responseBody case final Map<String, Object?> body) {
      final message = ErrorResponseDto.fromJson(body).message;
      if (message == 'Username is already taken') {
        return const UsernameUnavailableRegistrationFailure();
      }
    }

    return const UnknownRegistrationFailure();
  }
}
