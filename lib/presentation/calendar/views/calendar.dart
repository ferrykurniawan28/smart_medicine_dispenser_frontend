import 'package:flutter/material.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

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
              BrightnessMode.primary,
              BrightnessMode.secondary,
            ],
          ),
        ),
        child: ListView(
          children: [
            const Text(
              'Calendar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              // height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    focusedDay: DateTime.now(),
                  ),
                  const Divider(),
                  const Text('Selected Day'), //TODO: integrate selected day
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
