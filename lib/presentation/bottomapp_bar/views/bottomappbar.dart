import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/bottomapp_bar/controllers/bottomappbar_controller.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';

class Bottomappbar extends GetView<BottomappbarController> {
  const Bottomappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.currentPage,
      ),
      bottomNavigationBar: Obx(
        () => Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: BrightnessMode.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                iconSize: controller.currentIndex.value == 0 ? 35 : 25,
                onPressed: () {
                  controller.changeIndex(0);
                },
                color: controller.currentIndex.value == 0
                    ? Colors.blue
                    : Colors.grey,
              ),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                iconSize: controller.currentIndex.value == 1 ? 35 : 25,
                onPressed: () {
                  controller.changeIndex(1);
                },
                color: controller.currentIndex.value == 1
                    ? Colors.blue
                    : Colors.grey,
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                iconSize: controller.currentIndex.value == 2 ? 35 : 25,
                onPressed: () {
                  controller.changeIndex(2);
                },
                color: controller.currentIndex.value == 2
                    ? Colors.blue
                    : Colors.grey,
              ),
              IconButton(
                icon: const Icon(Icons.person),
                iconSize: controller.currentIndex.value == 3 ? 35 : 25,
                onPressed: () {
                  controller.changeIndex(3);
                },
                color: controller.currentIndex.value == 3
                    ? Colors.blue
                    : Colors.grey,
              ),
            ],
          ),
          // child: BottomNavigationBar(
          //   type: BottomNavigationBarType.shifting,
          //   selectedItemColor: Colors.blue,
          //   currentIndex: controller.currentIndex.value,
          //   onTap: controller.changeIndex,
          //   items: const [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.home),
          //       label: 'Home',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.calendar_month),
          //       label: 'Calendar',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.notifications),
          //       label: 'Notification',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.person),
          //       label: 'Profile',
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
