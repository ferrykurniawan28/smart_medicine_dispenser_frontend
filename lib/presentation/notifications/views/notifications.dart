import 'package:flutter/material.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/presentation/notifications/widgets/notificationwidget.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              BrightnessMode.secondary,
              BrightnessMode.primary,
            ],
          ),
        ),
        child: ListView(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            notificationCard(
              title: 'Medication Reminder',
              subtitle: 'Take your medication',
              time: '10:00 AM',
            ),
          ],
        ),
      ),
    );
  }
}
