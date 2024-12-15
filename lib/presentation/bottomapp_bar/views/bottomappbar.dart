import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/bottomapp_bar/controllers/bottomappbar_controller.dart';
import 'package:smart_dispencer/presentation/bottomapp_bar/widget/bottomwidget.dart';
import 'package:smart_dispencer/presentation/notifications/controllers/notificationcontroller.dart';

class Bottomappbar extends GetView<BottomappbarController> {
  const Bottomappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: BrightnessMode.primary,
      body: Stack(
        children: [
          Obx(
            () => controller.currentPage,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(
              () => Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // color: BrightnessMode.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(-10, 20),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildIconButton(
                      icon: Icons.home,
                      index: 0,
                      controller: controller,
                    ),
                    buildIconButton(
                      icon: Icons.devices,
                      index: 1,
                      controller: controller,
                    ),
                    buildIconButton(
                      icon: Icons.calendar_month,
                      index: 2,
                      controller: controller,
                    ),
                    buildIconButton(
                      icon: Icons.notifications,
                      index: 3,
                      controller: controller,
                      badgeCount: Get.find<NotificationController>()
                              .notifications
                              .isNotEmpty
                          ? Get.find<NotificationController>()
                              .notifications
                              .length
                          : 0,
                    ),
                    buildIconButton(
                      icon: Icons.person,
                      index: 4,
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
