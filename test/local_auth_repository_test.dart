import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_labs/data/local_auth_repository.dart';
import 'package:mobile_labs/domain/errors/domain_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes/memory_session_store.dart';

void main() {
  late SharedPreferences prefs;
  late MemorySessionStore session;
  late LocalAuthRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    session = MemorySessionStore();
    repo = LocalAuthRepository(prefs, session);
  });

  Future<void> registerDefault() =>
      repo.register(name: 'Олександр', email: 'a@b.com', password: 'secret123');

  test('реєстрація і вхід з правильним паролем', () async {
    await registerDefault();
    final user = await repo.signIn(email: 'a@b.com', password: 'secret123');
    expect(user.name, 'Олександр');
  });

  test('невірний пароль відхиляється', () async {
    await registerDefault();
    expect(
      repo.signIn(email: 'a@b.com', password: 'wrong12345'),
      throwsA(isA<DomainException>()),
    );
  });

  test('повторна реєстрація того самого email заборонена', () async {
    await registerDefault();
    expect(
      repo.register(name: 'Інший', email: 'A@B.com', password: 'secret123'),
      throwsA(isA<DomainException>()),
    );
  });

  test('невалідні дані не записуються', () async {
    expect(
      repo.register(name: 'Олег3', email: 'a@b.com', password: 'secret123'),
      throwsA(isA<DomainException>()),
    );
  });

  test('після входу сесія відновлюється в новому репозиторії', () async {
    await registerDefault();
    await repo.signIn(email: 'a@b.com', password: 'secret123');

    final LocalAuthRepository afterRestart = LocalAuthRepository(
      prefs,
      session,
    );
    final user = await afterRestart.restoreSession();
    expect(user?.email, 'a@b.com');
  });

  test('signOut очищає сесію', () async {
    await registerDefault();
    await repo.signIn(email: 'a@b.com', password: 'secret123');
    await repo.signOut();

    final LocalAuthRepository afterRestart = LocalAuthRepository(
      prefs,
      session,
    );
    expect(await afterRestart.restoreSession(), isNull);
  });

  test('сесія без існуючого користувача скидається', () async {
    await session.writeEmail('ghost@b.com');
    expect(await repo.restoreSession(), isNull);
    expect(await session.readEmail(), isNull);
  });
}
