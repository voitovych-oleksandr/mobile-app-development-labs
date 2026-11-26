import 'package:mobile_labs/domain/models/telemetry_reading.dart';

abstract interface class TelemetrySource {
  Stream<TelemetryReading> get readings;

  /// Повертає false, якщо брокер недоступний.
  Future<bool> connect();

  Future<void> disconnect();
}
