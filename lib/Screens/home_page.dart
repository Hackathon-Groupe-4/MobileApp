import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../Service/mqtt.dart';
import '../Widgets/SpeechBottomSheet.dart';
import '../Model/Device.dart';
import '../widgets/device_card.dart';

class MyHomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<MyHomePage> {
  final Mqtt mqtt = Mqtt(); // Instance MQTT
  SpeechBottomSheet? _speechBottomSheet;

  List<Device> devices = [
    Device(id: "ESP32Light", name: "Lumière Salon"),
    Device(id: "2", name: "Ventilateur"),
    Device(id: "3", name: "TV"),
    Device(id: "4", name: "Lampe Bureau"),
  ];

  @override
  void initState() {
    super.initState();
    mqtt.connect().then((_) {
      _subscribeToDevices();
    });

    // Écoute les mises à jour MQTT
    mqtt.client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        final recMess = message.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        print('📩 Message reçu sur ${message.topic}: $payload');

        // Identifier l'appareil concerné
        String deviceId = message.topic.replaceFirst('HomeConnect/', '');
        Device? device = devices.firstWhere((d) => d.id == deviceId, orElse: () => Device(id: '', name: ''));

        if (device.id.isNotEmpty) {
          setState(() {
            device.state = payload.trim().toUpperCase() == "ON";
          });
          print('🔄 ${device.name} est maintenant ${device.state ? "ALLUMÉ" : "ÉTEINT"}');
        }
      }
    });
  }

  void _subscribeToDevices() {
    for (var device in devices) {
      mqtt.subscribeToTopic('HomeConnect/${device.id}');
    }
    print('📡 Tous les topics ont été réabonnés.');
  }


  void toggleDevice(Device device) {
    mqtt.publishMessage("HomeConnect/${device.id}", !device.state ? "ON" : "OFF");
  }

  Future<void> _refreshDevices() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {}); // Met à jour l'interface
  }

  void _onCommandDetected(String? status, String sense) {
    print("Status: $status, Sense: $sense");

    Device? device = devices.firstWhere(
          (d) => d.name.toLowerCase() == sense.toLowerCase(),
      orElse: () => Device(id: '', name: ''),
    );

    if (device.id.isNotEmpty) {
      print("Appareil trouvé: ${device.name} (ID: ${device.id})");
      toggleDevice(device);
    } else {
      print("⚠️ Aucun appareil trouvé pour '$sense'");
    }
  }


  void _showSpeechBottomSheet() {
    _speechBottomSheet = SpeechBottomSheet(onCommandDetected: _onCommandDetected,);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _speechBottomSheet!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hackathon")),
      body: RefreshIndicator(
        onRefresh: _refreshDevices, // Fonction de rafraîchissement
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cartes par ligne
              childAspectRatio: 1.5, // Ratio pour éviter que les cartes soient trop grandes
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return DeviceCard(
                device: device,
                onToggle: () => toggleDevice(device),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSpeechBottomSheet();
        },
        tooltip: 'Écouter',
        child: Icon(SpeechBottomSheet.isNotListening() ? Icons.mic_off : Icons.mic),
      ),
    );
  }

}
