import 'dart:convert';
import 'package:Hackathon/Services/toast_service.dart';
import 'package:http/http.dart' as http;
import '../Model/Device.dart';

class DeviceService {
  static const String baseUrl = 'http://192.168.243.18:3000';

  // Fetch all devices
  static Future<List<Device>> getAllDevices() async {
    final response = await http.get(Uri.parse('$baseUrl/devices'));
    if (response.statusCode == 200) {
      ToastService.showToast("✅ Chargement des appareils...");
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((device) => Device.fromJson(device)).toList();
    } else {
      ToastService.showToast("❌ Echec du chargement des appareils...");
      throw Exception('Failed to load devices');
    }
  }
}