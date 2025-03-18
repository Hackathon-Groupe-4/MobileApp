import 'dart:convert';
import 'package:Hackathon/Services/toast_service.dart';
import 'package:http/http.dart' as http;
import '../Model/Device.dart';

class DeviceService {
  static const String baseUrl = 'http://192.168.243.18:3000';

  // Fetch all devices
  static Future<List<Device>> getAllDevices() async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/devices'));
      if (response.statusCode == 200) {
        ToastService.showToast("✅ Chargement des appareils...");
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((device) => Device.fromJson(device)).toList();
      } else {
        throw Exception('Failed to load devices');
      }
    }catch(Exection){
      ToastService.showToast("❌ Echec du chargement des appareils...");
      throw Exception('Failed to load devices');
    }

  }

  static Future<void> postTextToIa(String sentence) async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/openai'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'content': sentence}),
      );

      if (response.statusCode == 200) {
        print('✅ Réponse reçue: ${response.body}');
      } else {
        print('❌ Erreur: ${response.statusCode}');
        ToastService.showToast('❌ Erreur lors de l\'envoi du message vers IA');
      }
    }catch(Exection){
      ToastService.showToast('❌ Erreur lors de l\'envoi du message vers IA');
    }
  }

}