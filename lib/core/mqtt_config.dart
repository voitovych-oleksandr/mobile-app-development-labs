class MqttConfig {
  const MqttConfig._();

  static const String host = 'broker.hivemq.com';
  static const int port = 1883;
  // Публічний брокер бачать усі, тому топік з нікнеймом, а не просто sensor/temperature.
  static const String topic = 'powerplan/voitovych/sensor/temperature';
}
