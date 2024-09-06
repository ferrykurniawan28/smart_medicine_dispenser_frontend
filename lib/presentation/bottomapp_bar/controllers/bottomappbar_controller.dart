import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/home/controllers/homecontroller.dart';
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
        return Container();
      case 2:
        return Container();
      case 3:
        return Container();
      default:
        return Container();
    }
  }
}
