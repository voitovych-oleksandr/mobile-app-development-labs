import 'package:mobile_labs/domain/repositories/session_store.dart';

class MemorySessionStore implements SessionStore {
  String? _email;

  @override
  Future<String?> readEmail() async => _email;

  @override
  Future<void> writeEmail(String email) async {
    _email = email;
  }

  @override
  Future<void> clear() async {
    _email = null;
  }
}
