import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/presentation/home/controller/homecontroller.dart';
import 'package:smart_dispencer/presentation/home/widget/homewidget.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

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
              BrightnessMode.primary,
              BrightnessMode.secondary,
            ],
          ),
        ),
        child: ListView(
          children: [
            greatings(),
            GetBuilder<HomeController>(builder: (context) {
              return Text(controller.user?.name ?? 'No user',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ));
            }),
            barChart(),
            userPerformance(),
            motivation(10, 9),
            nextDose(),
          ],
        ),
      ),
    );
  }
}
