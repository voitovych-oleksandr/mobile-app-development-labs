import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/domain/repositories/session_store.dart';

class SecureSessionStore implements SessionStore {
  SecureSessionStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _key = 'session.email';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readEmail() => _storage.read(key: _key);

  @override
  Future<void> writeEmail(String email) =>
      _storage.write(key: _key, value: email);

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
