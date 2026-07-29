import 'package:flutter_test/flutter_test.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/auth/entities/app_identity.dart';
import 'package:nook/domain/auth/entities/auth_failure.dart';
import 'package:nook/domain/auth/repositories/auth_repository.dart';
import 'package:nook/domain/auth/use_cases/logout_use_case.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('LogoutUseCase', () {
    test('returns success when logout clears identity synchronously', () async {
      final repository = _FakeAuthRepository(
        const AuthenticatedAppIdentity(id: 'user-id'),
        onLogout: (repository) {
          repository.identitySubject.add(const AnonymousAppIdentity());
          return Future.value(Success.unit());
        },
      );
      final useCase = LogoutUseCase(repository);

      final result = await useCase();

      expect(result.isSuccess(), isTrue);
      await repository.close();
    });

    test('waits for identity to become anonymous before completing', () async {
      final repository = _FakeAuthRepository(
        const AuthenticatedAppIdentity(id: 'user-id'),
        onLogout: (repository) {
          Future<void>.delayed(Duration.zero, () {
            repository.identitySubject.add(const AnonymousAppIdentity());
          });
          return Future.value(Success.unit());
        },
      );
      final useCase = LogoutUseCase(repository);

      final result = await useCase();

      expect(result.isSuccess(), isTrue);
      expect(repository.identity.value, isA<AnonymousAppIdentity>());
      await repository.close();
    });

    test('returns logout error without waiting for identity', () async {
      final repository = _FakeAuthRepository(
        const AuthenticatedAppIdentity(id: 'user-id'),
        onLogout: (_) => Future.value(const Error(UnknownAuthFailure())),
      );
      final useCase = LogoutUseCase(repository);

      final result = await useCase();

      expect(result.isError(), isTrue);
      expect(repository.identity.value, isA<AuthenticatedAppIdentity>());
      await repository.close();
    });
  });
}

typedef _LogoutHandler =
    Future<Result<Unit, AuthFailure>> Function(_FakeAuthRepository repository);

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(
    AppIdentity initialIdentity, {
    required _LogoutHandler onLogout,
  }) : identitySubject = BehaviorSubject.seeded(initialIdentity),
       _onLogout = onLogout;

  final BehaviorSubject<AppIdentity> identitySubject;
  final _LogoutHandler _onLogout;

  @override
  ValueStream<AppIdentity> get identity => identitySubject.stream;

  @override
  Future<Result<Unit, AuthFailure>> loginWithPassword({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Unit, AuthFailure>> logout() {
    return _onLogout(this);
  }

  Future<void> close() {
    return identitySubject.close();
  }
}
