import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/registration_failure.dart';
import 'package:nook/domain/auth/repositories/registration_repository.dart';

/// Registers a user with a username, email address, and password.
class RegisterUseCase {
  /// Default constructor.
  const RegisterUseCase(this._registrationRepository);

  final RegistrationRepository _registrationRepository;

  /// Registers a user with the supplied account details.
  Future<Result<Unit, RegistrationFailure>> call({
    required String username,
    required String email,
    required String password,
  }) {
    return _registrationRepository.register(username: username, email: email, password: password);
  }
}
