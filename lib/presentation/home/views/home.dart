import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/presentation/home/controller/homecontroller.dart';
import 'package:smart_dispencer/presentation/home/widget/homewidget.dart';
import 'package:smart_dispencer/presentation/home/widget/nextreminder.dart';

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
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return RefreshIndicator(
                onRefresh: controller.refreshHome,
                child: ListView(
                  children: [
                    greatings(controller),
                    NextReminder(controller: controller),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          width: Get.width / 2,
                          // padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: BrightnessMode.secondary,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    )),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.grey, width: 2),
                                      ),
                                      child: const Text('Device Status'),
                                    ),
                                  ],
                                ),
                              ),
                              GetBuilder<HomeController>(
                                builder: (_) {
                                  return Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Temperature',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${controller.temperature ?? 2} °C',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ));
                                },
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              );
            }
          })),
    );
  }
}
