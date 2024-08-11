import 'package:get/get.dart';
import 'package:smart_dispencer/routes/pages_name.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed(PagesName.auth);
      // destroy controller
      Get.delete<SplashController>();
    });
    super.onInit();
  }
}
