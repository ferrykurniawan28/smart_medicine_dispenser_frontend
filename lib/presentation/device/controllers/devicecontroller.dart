import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/data/dummy/container.dart';

class Devicecontroller extends GetxController {
  StreamController<int> spinWheelController = StreamController<int>.broadcast();
  RxInt currentValue = 0.obs;
  TextEditingController medicineNameController = TextEditingController();

  @override
  void onInit() {
    spinWheelController.stream.listen((event) {
      currentValue.value = event;
    });
    super.onInit();
  }

  void spinRight() {
    spinWheelController
        .add((currentValue.value > -1) ? currentValue.value - 1 : 8);
    // spinWheelController.add(Fortune.randomInt(0, 8));
  }

  void spinLeft() {
    spinWheelController
        .add((currentValue.value < 8) ? currentValue.value + 1 : 0);
  }

  void settingContainer(int index) {
    int initQuantity = dummyContainer.values.elementAt(index)['quantity'] ?? 0;
    medicineNameController.text =
        dummyContainer.values.elementAt(index)['medicine'] ?? '';
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(10),
        height: 300,
        color: Colors.white,
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      initQuantity = (initQuantity > 0) ? initQuantity - 1 : 0;
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
              );
            }),
            ElevatedButton(
              onPressed: () {
                dummyContainer[index] = {
                  'medicine': medicineNameController.text,
                  'quantity': initQuantity,
                };
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
