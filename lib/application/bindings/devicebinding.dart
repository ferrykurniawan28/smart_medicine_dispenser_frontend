import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';

class Devicebinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Devicecontroller>(() => Devicecontroller());
  }
}
