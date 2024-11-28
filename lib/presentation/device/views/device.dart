import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';
import 'package:smart_dispencer/presentation/device/views/scan.dart';
import 'package:smart_dispencer/presentation/device/widgets/carouselcontainer.dart';
import 'package:smart_dispencer/presentation/device/widgets/listcontainer.dart';

class Device extends GetView<Devicecontroller> {
  const Device({super.key});

  @override
  Widget build(BuildContext context) {
    Widget showDevice() {
      return ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Device',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          CarouselContainer(controller: controller),
          // CarouselControl(controller: controller),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.blueAccent,
                          ),
                        ),
                        child: const Text('Containers'),
                      ),
                    ],
                  ),
                ),
                ListContainer(controller: controller),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ],
      );
    }

    Widget showEmpty() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No device found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const ScanBarcodeDevice());
            },
            child: const Text('Add Device'),
          ),
        ],
      );
    }

    Widget showLoading() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: BrightnessMode.primary,
        ),
        child: GetBuilder(
          init: controller,
          builder: (_) {
            return controller.isLoading.value
                ? showLoading()
                : (controller.device == null)
                    ? showEmpty()
                    : showDevice();
          },
        ),
      ),
    );
  }
}
