import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:smart_dispencer/data/services/authservice.dart';
import 'package:smart_dispencer/routes/pages_name.dart';

class SignInController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void signIn() async {
    if (formKey.currentState!.validate()) {
      ApiResponse apiResponse = await login(
        emailController.text,
        passwordController.text,
      );

      if (apiResponse.error == null) {
        Get.offAllNamed(PagesName.home);
        Get.snackbar(
          'Login Success',
          'Welcome to Medicine Smart Dispencer',
        );
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
