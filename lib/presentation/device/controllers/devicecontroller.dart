import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/data/dummy/container.dart';
import 'package:smart_dispencer/data/models/container.dart';

class Devicecontroller extends GetxController {
  RxInt currentValue = 0.obs;
  TextEditingController medicineNameController = TextEditingController();
  List<MedicineContainer> containers = [];
  CarouselSliderController carouselController = CarouselSliderController();
  final carouselKey = GlobalKey<CarouselSliderState>();

  @override
  void onInit() {
    containers = dummyContainer;
    super.onInit();
  }

  void spinRight() {
    carouselKey.currentState!.carouselController.nextPage();
    // carouselController.nextPage();
    if (currentValue.value < containers.length - 1) {
      currentValue.value += 1;
    } else {
      currentValue.value = 0;
    }
  }

  void spinLeft() {
    carouselController.previousPage();
    if (currentValue.value > 0) {
      currentValue.value -= 1;
    } else {
      currentValue.value = containers.length - 1;
    }
  }

  void settingContainer(int index) {
    int initQuantity = containers[index].quantity ?? 0;
    medicineNameController.text = containers[index].medicine ?? '';
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(10),
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Container ${index + 1}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            TextFormField(
              controller: medicineNameController,
              decoration: const InputDecoration(
                hintText: 'Medicine name',
                // labelText: 'Medicine name',
              ),
            ),
            StatefulBuilder(builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          initQuantity =
                              (initQuantity > 0) ? initQuantity - 1 : 0;
                          setState(() {});
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(initQuantity.toString()),
                      IconButton(
                        onPressed: () {
                          initQuantity = initQuantity + 1;
                          setState(() {});
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      medicineNameController.clear();
                      initQuantity = 0;
                      setState(() {});
                    },
                    child: const Text('Reset'),
                  ),
                ],
              );
            }),
            ElevatedButton(
              onPressed: () {
                containers[index].medicine = medicineNameController.text;
                containers[index].quantity = initQuantity;
                update();
                Get.back();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
