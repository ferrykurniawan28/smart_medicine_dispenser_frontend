import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/calendar/controllers/calendarcontroller.dart';
import 'package:smart_dispencer/presentation/calendar/widgets/constantwidget.dart';
import 'package:smart_dispencer/presentation/calendar/widgets/floatbutton.dart';
import 'package:smart_dispencer/presentation/calendar/widgets/reminderlist.dart';
import 'package:smart_dispencer/presentation/calendar/widgets/tablecalendar.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';

class Calendar extends GetView<CalendarController> {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (_) {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Stack(
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
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                GetBuilder(
                  init: controller,
                  initState: (_) {},
                  builder: (_) {
                    if (Get.find<Devicecontroller>().device == null) {
                      return const SizedBox();
                    } else {
                      return FloatButtonCalendar(controller: controller);
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
