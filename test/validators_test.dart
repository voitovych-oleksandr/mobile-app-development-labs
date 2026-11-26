import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_labs/domain/validators/validators.dart';

void main() {
  group('AuthValidator.email', () {
    test('відхиляє адресу без @', () {
      expect(AuthValidator.email('user.example.com'), isNotNull);
    });
    test('відхиляє адресу без домену', () {
      expect(AuthValidator.email('user@'), isNotNull);
    });
    test('приймає коректну адресу', () {
      expect(AuthValidator.email('user@example.com'), isNull);
    });
  });

  group('AuthValidator.password', () {
    test('відхиляє пароль коротший за 8 символів', () {
      expect(AuthValidator.password('1234567'), isNotNull);
    });
    test('приймає пароль із 8 символів', () {
      expect(AuthValidator.password('12345678'), isNull);
    });
  });

  group('AuthValidator.name', () {
    test('відхиляє ім\'я з цифрами', () {
      expect(AuthValidator.name('Олег3'), isNotNull);
    });
    test('приймає коректне ім\'я', () {
      expect(AuthValidator.name('Олександр'), isNull);
    });
  });

  group('OutageValidator.range', () {
    test('відхиляє кінець раніше за початок', () {
      expect(OutageValidator.range(10, 8), isNotNull);
    });
    test('приймає коректний інтервал', () {
      expect(OutageValidator.range(8, 12), isNull);
    });
  });
}
