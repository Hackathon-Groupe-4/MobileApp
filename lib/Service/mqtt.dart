import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:math';

class Mqtt {
  final String broker = '192.168.243.95'; // Remplace par ton broker
  final String clientIdentifier = 'flutter_client_${Random().nextInt(100000)}';
  MqttServerClient? client;
  Timer? _reconnectTimer;

  Future<void> connect() async {
    client = MqttServerClient(broker, clientIdentifier);
    client!.logging(on: true);
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.onConnected = onConnected;
    client!.onSubscribed = onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .withWillQos(MqttQos.exactlyOnce);
    client!.connectionMessage = connMessage;

    try {
      await client!.connect();
      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        print('✅ MQTT connecté');
        _reconnectTimer?.cancel(); // Annule la reconnexion si c'est OK
      } else {
        print('❌ Connexion échouée, état: ${client!.connectionStatus!.state}');
        client!.disconnect();
        _startReconnect(); // Tente une reconnexion
      }
    } catch (e) {
      print('⚠️ Exception MQTT: $e');
      client!.disconnect();
      _startReconnect(); // Tente une reconnexion
    }
  }

  void _startReconnect() {
    if (_reconnectTimer == null || !_reconnectTimer!.isActive) {
      print('🔄 Tentative de reconnexion dans 5 secondes...');
      _reconnectTimer = Timer(Duration(seconds: 5), connect);
    }
  }

  void onConnected() {
    print('✅ MQTT connecté');
  }

  void onDisconnected() {
    print('❌ MQTT déconnecté, tentative de reconnexion...');
    _startReconnect(); // Relance la connexion automatiquement
  }

  void onSubscribed(String topic) {
    print('📌 Abonné à: $topic');
  }

  void subscribeToTopic(String topic) {
    client!.subscribe(topic, MqttQos.exactlyOnce);
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }
}
