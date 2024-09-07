import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/home/controller/homecontroller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: GetBuilder<HomeController>(builder: (context) {
            return Text(controller.user?.name ?? 'No user');
          }),
        ),
      ),
    );
  }
}
