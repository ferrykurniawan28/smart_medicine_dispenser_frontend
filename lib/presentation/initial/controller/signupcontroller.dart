import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:smart_dispencer/data/models/user.dart';
import 'package:smart_dispencer/data/services/authservice.dart';
import 'package:smart_dispencer/routes/pages_name.dart';

class SignUpController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void signUp() async {
    if (formKey.currentState!.validate()) {
      ApiResponse apiResponse = await register(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      if (apiResponse.error == null) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        ApiResponse response =
            await storeUserFcmToken(apiResponse.data as User, fcmToken!);

        if (response.error == null) {
          final providerUser = ProviderUser();
          await providerUser.open(tableUser);
          await providerUser.insertOrUpdate(apiResponse.data as User);
          Get.offAllNamed(PagesName.home);
          Get.snackbar(
            'Register  Success',
            'Welcome to Minder',
          );
        } else {
          Get.snackbar(
            'Error',
            response.error.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          apiResponse.error.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
