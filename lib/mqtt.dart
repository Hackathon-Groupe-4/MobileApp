import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Mqtt {
  final String broker = '192.168.238.56'; // Remplacez par votre broker MQTT
  final String clientIdentifier = 'flutter_client';
  MqttServerClient? client;

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
        print('MQTT client connected');
        subscribeToTopic('arrosage/manuel'); // Remplacez par votre sujet
      } else {
        print(
            'MQTT client connection failed - disconnecting, state is ${client!.connectionStatus!.state}');
        client!.disconnect();
      }
    } catch (e) {
      print('Exception: $e');
      client!.disconnect();
    }
  }

  void subscribeToTopic(String topic) {
    client!.subscribe(topic, MqttQos.exactlyOnce);
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void onConnected() {
    print('MQTT client connected');
  }

  void onDisconnected() {
    print('MQTT client disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }
}
