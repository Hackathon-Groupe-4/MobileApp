import 'package:flutter/material.dart';
import '../Service/mqtt.dart';
import '../Widgets/SpeechBottomSheet.dart';
import '../Model/Device.dart';
import '../widgets/device_card.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
    mqtt.connect(); // Connexion automatique à MQTT
  }

  void toggleDevice(Device device) {
    setState(() {
      device.state = !device.state;
    });
    mqtt.publishMessage("HomeConnect/${device.id}", device.state ? "ON" : "OFF");
  }

  Future<void> _refreshDevices() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {}); // Met à jour l'interface
  }

  void _onCommandDetected(String? status, List<String> words) {
    print("Status: $status, Words: $words");
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
