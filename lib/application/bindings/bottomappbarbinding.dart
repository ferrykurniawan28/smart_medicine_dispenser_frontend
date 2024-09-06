import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/bottomapp_bar/controllers/bottomappbar_controller.dart';

class BottomAppBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomappbarController>(() => BottomappbarController());
  }
}
