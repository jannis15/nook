import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

/// Provides the current application identity stream.
class WatchIdentityUseCase {
  /// Default constructor.
  const WatchIdentityUseCase(this._authRepository);

  final AuthRepository _authRepository;

  /// Returns the current application identity stream.
  ValueStream<AppIdentity> call() {
    return _authRepository.identity;
  }
}
