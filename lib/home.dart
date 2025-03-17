import 'package:flutter/material.dart';
import 'mqtt.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hackathon',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<MyHomePage> {
  final Mqtt mqtt = Mqtt(); // Instance MQTT
  bool state = false;

  @override
  void initState() {
    super.initState();
    mqtt.connect(); // Connexion automatique à MQTT
  }

  void sendMessage() {
    mqtt.publishMessage("HomeConnect/ESP32Light", state?"OFF":"ON"); // Envoi du message
    state=!state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hackathon")),
      body: Center(
        child: ElevatedButton(
          onPressed: sendMessage,
          child: Text("Envoyer un message"),
        ),
      ),
    );
  }
}
