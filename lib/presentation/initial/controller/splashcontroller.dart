import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/data/models/reminder.dart';
import 'package:smart_dispencer/data/models/user.dart';
import 'package:smart_dispencer/routes/pages_name.dart';

class SplashController extends GetxController {
  late final ProviderUser providerUser;
  late final ProviderMedicineReminder providerMedicineReminder;

  @override
  void onInit() async {
    initializeApp();
    super.onInit();
  }

  Future<void> initializeApp() async {
    try {
      providerUser = ProviderUser();
      providerMedicineReminder = ProviderMedicineReminder();
      await providerMedicineReminder.open(tableReminder);

      final loggedIn = await isLoggedIn();

      await Future.delayed(const Duration(seconds: 3));

      if (loggedIn) {
        Get.offNamed(PagesName.home);
      } else {
        Get.offNamed(PagesName.auth);
      }

      // Destroy controller
      Get.delete<SplashController>();
    } catch (e) {
      debugPrint("Error initializing app: $e");
    }
  }

  // check if user is logged in
  Future<bool> isLoggedIn() async {
    final providerUser = ProviderUser();
    await providerUser.open(tableUser);
    final user = await providerUser.getUser();
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> initDatabase() async {
    await providerUser.open(tableUser);
    await providerMedicineReminder.open(tableReminder);
  }
}
