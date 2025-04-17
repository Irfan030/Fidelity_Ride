import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      appBar: AppBar(title: const Text('Notification')),
      body: const Center(child: Text('Notification   Screen')),
    );
  }
}
