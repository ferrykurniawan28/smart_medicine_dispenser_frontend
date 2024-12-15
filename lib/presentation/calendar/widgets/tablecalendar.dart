import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/calendar/controllers/calendarcontroller.dart';
import 'package:table_calendar/table_calendar.dart';

class MedicineCalendar extends StatelessWidget {
  const MedicineCalendar({
    super.key,
    required this.controller,
  });

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        builder: (CalendarController controller) => TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365 * 2)),
              lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
              focusedDay: controller.focusedDay.value,
              calendarFormat: controller.calendarFormat.value,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerVisible: true,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDay.value, day),
              onDaySelected: controller.onDaySelected,
              onFormatChanged: (format) {
                controller.calendarFormat.value = format;
              },
              onPageChanged: (focusedDay) {
                controller.focusedDay.value = focusedDay;
              },
              eventLoader: controller.getEventsForDay,
            ));
  }
}
