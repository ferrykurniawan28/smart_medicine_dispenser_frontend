import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/routes/pages_name.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    // check if device is android or ios
    bool isAndroid = Platform.isAndroid;

    return Scaffold(
        // backgroundColor: BrightnessMode.secondary,
        body: ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          height: Get.height * 0.7,
          decoration: const BoxDecoration(
            // color: BrightnessMode.primary, //TODO: change color
            gradient: LinearGradient(colors: [
              BrightnessMode.primary,
              BrightnessMode.secondary,
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'MINDER',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.medication_sharp,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              SocialLoginButton(
                buttonType: SocialLoginButtonType.google,
                onPressed: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              SocialLoginButton(
                buttonType: SocialLoginButtonType.facebook,
                onPressed: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              if (!isAndroid)
                SocialLoginButton(
                  buttonType: SocialLoginButtonType.apple,
                  onPressed: () {},
                ),
              if (!isAndroid)
                const SizedBox(
                  height: 10,
                ),
              SocialLoginButton(
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () => Get.toNamed(PagesName.login),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          height: Get.height * 0.3,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Don\'t have an account?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => Get.toNamed(PagesName.register),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                  backgroundColor: BrightnessMode.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
