class AuthValidator {
  const AuthValidator._();

  static const int minPasswordLength = 8;
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _digitPattern = RegExp(r'\d');

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Введіть електронну пошту';
    if (!_emailPattern.hasMatch(text)) {
      return 'Некоректна адреса: потрібні @ та домен, наприклад name@mail.com';
    }
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Введіть пароль';
    if (text.length < minPasswordLength) {
      return 'Пароль має містити щонайменше $minPasswordLength символів';
    }
    return null;
  }

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return "Введіть ім'я";
    if (_digitPattern.hasMatch(text)) return "Ім'я не може містити цифр";
    return null;
  }

  static String? confirmPassword(String password, String? confirm) {
    if ((confirm ?? '').isEmpty) return 'Підтвердіть пароль';
    if (confirm != password) return 'Паролі не збігаються';
    return null;
  }
}

class OutageValidator {
  const OutageValidator._();

  static String? range(int startHour, int endHour) {
    if (startHour < 0 || endHour > 24) {
      return 'Години мають бути в межах 0–24';
    }
    if (endHour <= startHour) {
      return 'Кінець відключення має бути пізніше за початок';
    }
    return null;
  }
}
