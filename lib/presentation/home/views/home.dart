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
        child: RefreshIndicator(
          onRefresh: controller.refreshHome,
          child: ListView(
            children: [
              greatings(controller),
              Container(
                height: 300,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: const Text('Upcoming Reminder'),
                          ),
                        ],
                      ),
                    ),
                    // const Divider(),
                    GetBuilder<HomeController>(
                      builder: (_) {
                        if (controller.reminders.isEmpty) {
                          return const Expanded(
                            child: Center(
                              child: Text('No reminder for today'),
                            ),
                          );
                        }
                        return Container(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: controller.reminders.length,
                            itemBuilder: (context, index) {
                              return reminderList(
                                  controller.reminders[index].medicineTime,
                                  controller
                                      .reminders[index].medicineDosage.keys
                                      .map((key) =>
                                          ': ${controller.reminders[index].medicineDosage[key]}')
                                      .join(', '),
                                  controller.reminders[index].medicineTime,
                                  controller
                                      .reminders[index].medicineDosage.keys
                                      .map((key) =>
                                          ': ${controller.reminders[index].medicineDosage[key]}')
                                      .join(', '));
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // barChart(),
              // userPerformance(),
              // motivation(10, 9),
              // nextDose(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
