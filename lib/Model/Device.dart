class Device {
  final String id;
  final String name;
  bool state; // true = allumé, false = éteint

  Device({required this.id, required this.name, this.state = false});
}