abstract interface class SessionStore {
  Future<String?> readEmail();
  Future<void> writeEmail(String email);
  Future<void> clear();
}
