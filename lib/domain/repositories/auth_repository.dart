import 'package:mobile_labs/domain/models/user.dart';

abstract interface class AuthRepository {
  User? get currentUser;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  Future<User> signIn({required String email, required String password});

  Future<void> signOut();
}
