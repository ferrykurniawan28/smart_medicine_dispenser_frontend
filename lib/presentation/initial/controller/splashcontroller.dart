import 'package:get/get.dart';
import 'package:smart_dispencer/routes/pages_name.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      // Get.offNamed(PagesName.home);
    });
  }
}
