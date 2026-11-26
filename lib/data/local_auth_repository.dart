import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:mobile_labs/domain/errors/domain_exception.dart';
import 'package:mobile_labs/domain/models/user.dart';
import 'package:mobile_labs/domain/repositories/auth_repository.dart';
import 'package:mobile_labs/domain/repositories/session_store.dart';
import 'package:mobile_labs/domain/validators/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._prefs, this._session);

  static const _usersKey = 'auth.users';

  final SharedPreferences _prefs;
  final SessionStore _session;
  User? _current;

  @override
  User? get currentUser => _current;

  @override
  Future<User?> restoreSession() async {
    final String? email = await _session.readEmail();
    if (email == null) return null;

    final Map<String, dynamic>? record =
        _readUsers()[email] as Map<String, dynamic>?;
    if (record == null) {
      await _session.clear();
      return null;
    }

    _current = User(email: email, name: record['name'] as String);
    return _current;
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final error =
        AuthValidator.name(name) ??
        AuthValidator.email(email) ??
        AuthValidator.password(password);
    if (error != null) throw DomainException(error);

    final key = _normalize(email);
    final users = _readUsers();
    if (users.containsKey(key)) {
      throw const DomainException('Користувач з таким email уже існує');
    }

    final salt = _newSalt();
    users[key] = {
      'name': name.trim(),
      'salt': salt,
      'hash': _hash(salt, password),
    };
    await _prefs.setString(_usersKey, jsonEncode(users));
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    final key = _normalize(email);
    final record = _readUsers()[key] as Map<String, dynamic>?;

    if (record == null ||
        _hash(record['salt'] as String, password) != record['hash']) {
      throw const DomainException('Невірний email або пароль');
    }

    final user = User(email: key, name: record['name'] as String);
    _current = user;
    await _session.writeEmail(key);
    return user;
  }

  @override
  Future<void> signOut() async {
    _current = null;
    await _session.clear();
  }

  Map<String, dynamic> _readUsers() {
    final raw = _prefs.getString(_usersKey);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  String _normalize(String email) => email.trim().toLowerCase();

  String _newSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _hash(String salt, String password) =>
      sha256.convert(utf8.encode('$salt$password')).toString();
}
