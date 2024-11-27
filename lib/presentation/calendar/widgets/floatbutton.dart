import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smart_dispencer/presentation/calendar/controllers/calendarcontroller.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';

class FloatButtonCalendar extends StatelessWidget {
  const FloatButtonCalendar({
    super.key,
    required this.controller,
  });

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      right: 20,
      child: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        backgroundColor: BrightnessMode.secondary,
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            backgroundColor: BrightnessMode.primary,
            label: 'Add Reminder',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: controller.openDialog,
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit),
            backgroundColor: BrightnessMode.primary,
            label: 'Edit Reminder',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              controller.isEditing.value = !controller.isEditing.value;
            },
          ),
        ],
      ),
    );
  }
}
