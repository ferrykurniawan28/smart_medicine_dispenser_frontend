import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/calendar/controllers/calendarcontroller.dart';
import 'package:smart_dispencer/presentation/calendar/views/calendar.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';
import 'package:smart_dispencer/presentation/device/views/device.dart';
import 'package:smart_dispencer/presentation/home/controller/homecontroller.dart';
import 'package:smart_dispencer/presentation/home/views/home.dart';
import 'package:smart_dispencer/presentation/notifications/views/notifications.dart';
import 'package:smart_dispencer/presentation/profile/view/profile.dart';

class BottomappbarController extends GetxController {
  var currentIndex = 0.obs;

  @override
  void onInit() {
    Get.put(HomeController());
    Get.put(Devicecontroller());
    Get.put(CalendarController());
    super.onInit();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Widget get currentPage {
    switch (currentIndex.value) {
      case 0:
        return const Home();
      case 1:
        return const Device();
      case 2:
        return const Calendar();
      case 3:
        return const Notifications();
      case 4:
        return const Profile();
      default:
        return Container();
    }
  }
}
