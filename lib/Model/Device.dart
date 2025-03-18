class Device {
  final String id;
  final String name;
  bool state; // true = allumé, false = éteint

  Device({required this.id, required this.name, this.state = false});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json["id"],
      name: json["name"],
      state: json["state"],
    );
  }
}