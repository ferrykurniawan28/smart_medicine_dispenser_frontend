import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/calendar/controllers/calendarcontroller.dart';
import 'package:smart_dispencer/presentation/calendar/widgets/constantwidget.dart';
import 'package:smart_dispencer/presentation/calendar/widgets/floatbutton.dart';
import 'package:smart_dispencer/presentation/calendar/widgets/reminderlist.dart';
import 'package:smart_dispencer/presentation/calendar/widgets/tablecalendar.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';

class Calendar extends GetView<CalendarController> {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: BrightnessMode.primary,
            ),
            child: ListView(
              children: [
                titleCalendar(),
                const SizedBox(height: 10),
                Container(
                  // height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      MedicineCalendar(controller: controller),
                      const Divider(),
                      selectedDay(controller),
                      const Divider(),
                      const SizedBox(height: 10),
                      ReminderList(controller: controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FloatButtonCalendar(controller: controller),
        ],
      ),
    );
  }
}
