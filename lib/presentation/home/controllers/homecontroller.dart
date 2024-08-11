import 'dart:async';

import 'package:get/get.dart';

class HomeController extends GetxController {
  StreamController<int> spinWheelController = StreamController<int>.broadcast();
  RxInt currentValue = 0.obs;

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

  // void changeValue(int value) {
  //   // print(value);
  //   spinWheelController.add(value);
  // }
}
