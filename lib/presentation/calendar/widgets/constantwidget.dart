import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_dispencer/presentation/calendar/controllers/calendarcontroller.dart';

Widget titleCalendar() {
  return const Text(
    'Calendar',
    style: TextStyle(
      color: Colors.white,
      fontSize: 30,
    ),
  );
}

Widget selectedDay(CalendarController controller) {
  return Obx(
    () => Text(
      DateFormat.yMMMMEEEEd('en_US')
          .format(controller.selectedDay.value ?? controller.focusedDay.value),
    ),
  );
}
