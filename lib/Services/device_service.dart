import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/Device.dart';

class DeviceService {
  static const String baseUrl = 'http://192.168.243.18:3000';

  // Fetch all devices
  static Future<List<Device>> getAllDevices() async {
    final response = await http.get(Uri.parse('$baseUrl/devices'));
    print("#######################################");
    print("#######################################");
    print("Appel " + response.statusCode.toString());
    print("#######################################");
    print("#######################################");
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((device) => Device.fromJson(device)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }
}