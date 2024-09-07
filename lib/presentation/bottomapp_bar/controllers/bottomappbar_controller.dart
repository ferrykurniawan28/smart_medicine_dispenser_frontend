import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';
import 'package:smart_dispencer/presentation/device/views/device.dart';
import 'package:smart_dispencer/presentation/home/controller/homecontroller.dart';
import 'package:smart_dispencer/presentation/home/views/home.dart';

class BottomappbarController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Widget get currentPage {
    switch (currentIndex.value) {
      case 0:
        Get.lazyPut<HomeController>(() => HomeController());
        return const Home();
      case 1:
        Get.lazyPut<Devicecontroller>(() => Devicecontroller());
        return const Device();
      case 2:
        return Container();
      case 3:
        return Container();
      case 4:
        return Container();
      default:
        return Container();
    }
  }
}
