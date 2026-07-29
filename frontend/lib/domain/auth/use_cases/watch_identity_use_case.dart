import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class WatchIdentityUseCase {
  const WatchIdentityUseCase(this._authRepository);

  final AuthRepository _authRepository;

  ValueStream<AppIdentity> call() {
    return _authRepository.identity;
  }
}
