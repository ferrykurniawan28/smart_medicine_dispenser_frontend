import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/presentation/notifications/controllers/notificationcontroller.dart';
import 'package:smart_dispencer/presentation/notifications/widgets/notificationwidget.dart';

class Notifications extends GetView<NotificationController> {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              BrightnessMode.secondary,
              BrightnessMode.primary,
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.notifications.isEmpty) {
            return const Center(
              child: Text('No notifications'),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshNotifications,
            child: ListView.builder(
              controller: controller.scrollController,
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return notificationCard(
                  message: notification.message,
                  time: DateFormat.jm().format(notification.sentAt),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
