import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:smart_dispencer/data/models/notification.dart';
import 'package:smart_dispencer/data/services/notificationservice.dart';
import 'package:smart_dispencer/presentation/home/controller/homecontroller.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationHistory>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  RxInt pageIndex = 1.obs;
  final int perPage = 10;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getNotifications();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getNotifications();
      }
    });
  }

  Future<void> refreshNotifications() async {
    pageIndex.value = 1;
    hasMore.value = true;
    notifications.clear();
    await getNotifications();
  }

  Future<void> getNotifications() async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;

    int? userId = Get.find<HomeController>().user?.id;

    ApiResponse apiResponse =
        await fetchNotification(pageIndex.value, perPage, userId!);

    if (apiResponse.error == null) {
      List<NotificationHistory> newNotifications;
      if (apiResponse.data is List<NotificationHistory>) {
        newNotifications = apiResponse.data as List<NotificationHistory>;
      } else {
        newNotifications = [];
      }

      if (newNotifications.length < perPage) {
        hasMore.value = false;
      }

      notifications.addAll(newNotifications);
      pageIndex.value++;
    } else {
      print('error: ${apiResponse.error}');
    }

    isLoading.value = false;
  }
}
