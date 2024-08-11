import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          height: Get.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.grey, //TODO: change color
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Pill Reminder',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
              SocialLoginButton(
                buttonType: SocialLoginButtonType.apple,
                onPressed: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              SocialLoginButton(
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () {},
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
                onPressed: () {},
                // style: ElevatedButton.styleFrom(
                //   textStyle: const TextStyle(
                //     fontSize: 20,
                //     color: Colors.white,
                //   ),
                //   backgroundColor: Colors.greenAccent,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                // ),
                child: const Text(
                  'Sign Up',
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
