import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Model/Device.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onToggle;

  DeviceCard({required this.device, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: device.state ? Colors.yellow.shade200 : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            device.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onToggle,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15), // Ajoute du padding interne au bouton
            ),
            child: SvgPicture.asset(
              'assets/icons/power.svg',
              width: 35,
              height: 35,
              colorFilter: ColorFilter.mode(
                device.state ? Colors.red : Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
