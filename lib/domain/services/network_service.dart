abstract interface class NetworkService {
  /// Разова перевірка стану мережі.
  Future<bool> isOnline();

  /// Потік змін стану мережі. Надсилає значення лише при зміні.
  Stream<bool> get onlineChanges;
}
