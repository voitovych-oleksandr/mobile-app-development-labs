import 'dart:async';

import 'package:mobile_labs/core/mqtt_config.dart';
import 'package:mobile_labs/domain/models/telemetry_reading.dart';
import 'package:mobile_labs/domain/services/telemetry_source.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttTelemetrySource implements TelemetrySource {
  final StreamController<TelemetryReading> _controller =
      StreamController<TelemetryReading>.broadcast();

  MqttServerClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _updatesSub;
  Future<bool>? _pendingConnect;

  @override
  Stream<TelemetryReading> get readings => _controller.stream;

  @override
  Future<bool> connect() {
    // Друге підключення під час першого обірве перше,
    // тому повертаємо результат поточної спроби.
    final Future<bool>? pending = _pendingConnect;
    if (pending != null) return pending;

    final Future<bool> attempt = _connectOnce();
    _pendingConnect = attempt;
    return attempt.whenComplete(() => _pendingConnect = null);
  }

  Future<bool> _connectOnce() async {
    await disconnect();

    final String clientId =
        'powerplan_${DateTime.now().millisecondsSinceEpoch}';
    final MqttServerClient client =
        MqttServerClient.withPort(MqttConfig.host, clientId, MqttConfig.port)
          ..logging(on: false)
          ..keepAlivePeriod = 20
          ..connectionMessage = MqttConnectMessage()
              .withClientIdentifier(clientId)
              .startClean();
    _client = client;

    try {
      await client.connect().timeout(const Duration(seconds: 15));
    } catch (_) {
      await disconnect();
      return false;
    }

    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      await disconnect();
      return false;
    }

    client.subscribe(MqttConfig.topic, MqttQos.atLeastOnce);
    _updatesSub = client.updates?.listen(_onMessages);
    return true;
  }

  @override
  Future<void> disconnect() async {
    await _updatesSub?.cancel();
    _updatesSub = null;
    _client?.disconnect();
    _client = null;
  }

  void _onMessages(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (final MqttReceivedMessage<MqttMessage> received in messages) {
      final MqttMessage message = received.payload;
      if (message is! MqttPublishMessage) continue;

      final String payload = MqttPublishPayload.bytesToStringAsString(
        message.payload.message,
      );
      _controller.add(
        TelemetryReading(
          topic: received.topic,
          payload: payload,
          receivedAt: DateTime.now(),
        ),
      );
    }
  }
}
