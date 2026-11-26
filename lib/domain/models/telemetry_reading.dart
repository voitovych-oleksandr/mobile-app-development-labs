class TelemetryReading {
  const TelemetryReading({
    required this.topic,
    required this.payload,
    required this.receivedAt,
  });

  final String topic;
  final String payload;
  final DateTime receivedAt;

  double? get numericValue =>
      double.tryParse(payload.trim().replaceAll(',', '.'));
}
