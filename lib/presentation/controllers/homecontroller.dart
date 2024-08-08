import 'dart:async';

import 'package:get/get.dart';

class HomeController extends GetxController {
  StreamController<int> spinWheelController = StreamController<int>();
  late StreamSubscription<int> _subscription;
  RxInt currentValue = 0.obs;

  Stream<int> get spinWheelStream => spinWheelController.stream;

  @override
  void onInit() {
    _subscription = spinWheelController.stream.listen((event) {
      currentValue.value = event;
    });
    super.onInit();
  }

  void spinRight() {
    spinWheelController.add(currentValue.value - 1);
  }

  void spinLeft() {
    spinWheelController.add(currentValue.value + 1);
  }
}