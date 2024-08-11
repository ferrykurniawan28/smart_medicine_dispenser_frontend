import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/initial/controller/splashcontroller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
