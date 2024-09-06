import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/home/controllers/homecontroller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
