import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:math';
import "./toast_service.dart";

class Mqtt {
  final String broker = '192.168.243.95'; // Remplace par ton broker
  final String clientIdentifier = 'flutter_client_${Random().nextInt(100000)}';
  MqttServerClient? client;

  Future<void> connect() async {
    client = MqttServerClient(broker, clientIdentifier);
    client!.logging(on: true);
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.onConnected = onConnected;
    client!.onSubscribed = onSubscribed;

    // ✅ Active la reconnexion automatique
    client!.autoReconnect = true;
    client!.resubscribeOnAutoReconnect = true;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .withWillQos(MqttQos.exactlyOnce);
    client!.connectionMessage = connMessage;

    try {
      await client!.connect();
      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        print('✅ MQTT connecté');
      } else {
        print('❌ Connexion échouée, état: ${client!.connectionStatus!.state}');
        client!.disconnect();
      }
    } catch (e) {
      print('⚠️ Exception MQTT: $e');
      client!.disconnect();
    }
  }

  void onConnected() {
    ToastService.showToast('✅ MQTT connecté');
    //print('✅ MQTT connecté');
  }

  void onDisconnected() {
    ToastService.showToast('❌ MQTT déconnecté, tentative de reconnexion...');
    //print('❌ MQTT déconnecté, tentative de reconnexion...');
  }

  void onSubscribed(String topic) {
    print('📌 Abonné à: $topic');
  }

  void subscribeToTopic(String topic) {
    client!.subscribe(topic, MqttQos.exactlyOnce);
  }

  void publishMessage(String topic, String message) {
    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
    catch (e) {
      ToastService.showToast("❌ Echec de l'envoi du message");
    }
  }
}
