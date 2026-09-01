import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/data/auth/dtos/email_verification_status_response_dto.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:nook/domain/auth/repositories/email_verification_repository.dart';

/// An API-backed email verification repository.
class EmailVerificationRepositoryImpl implements EmailVerificationRepository {
  /// Default constructor.
  const EmailVerificationRepositoryImpl(this._dio);

  static final _logger = Logger((EmailVerificationRepositoryImpl).toString());

  final Dio _dio;

  @override
  Future<Result<bool, AuthFailure>> getEmailVerificationStatus() async {
    try {
      final response = await _dio.get<Map<String, Object?>>('/profiles/me/email-verification');
      final body = response.data;
      if (body == null) {
        return const Error(UnknownAuthFailure());
      }

      return Success(EmailVerificationStatusResponseDto.fromJson(body).isEmailVerified);
    } on DioException catch (error) {
      _logger.warning('Could not load the email verification status.', error, error.stackTrace);
      return const Error(UnknownAuthFailure());
    } catch (error, stackTrace) {
      _logger.severe('Could not load the email verification status.', error, stackTrace);
      return const Error(UnknownAuthFailure());
    }
  }
}
