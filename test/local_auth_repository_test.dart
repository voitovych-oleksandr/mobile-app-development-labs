import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_labs/data/local_auth_repository.dart';
import 'package:mobile_labs/domain/errors/domain_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalAuthRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repo = LocalAuthRepository(prefs);
  });

  test('реєстрація і вхід з правильним паролем', () async {
    await repo.register(
      name: 'Олександр',
      email: 'a@b.com',
      password: 'secret123',
    );
    final user = await repo.signIn(email: 'a@b.com', password: 'secret123');
    expect(user.name, 'Олександр');
  });

  test('невірний пароль відхиляється', () async {
    await repo.register(
      name: 'Олександр',
      email: 'a@b.com',
      password: 'secret123',
    );
    expect(
      repo.signIn(email: 'a@b.com', password: 'wrong12345'),
      throwsA(isA<DomainException>()),
    );
  });

  test('повторна реєстрація того самого email заборонена', () async {
    await repo.register(
      name: 'Олександр',
      email: 'a@b.com',
      password: 'secret123',
    );
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
}
