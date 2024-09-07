import 'package:get/get.dart';
import 'package:smart_dispencer/data/models/user.dart';
import 'package:smart_dispencer/routes/pages_name.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    final loggedIn = await isLoggedIn();
    Future.delayed(const Duration(seconds: 3), () {
      if (loggedIn) {
        Get.offNamed(PagesName.home);
      } else {
        Get.offNamed(PagesName.login);
      }

      // destroy controller
      Get.delete<SplashController>();
    });
    super.onInit();
  }

  // check if user is logged in
  Future<bool> isLoggedIn() async {
    final providerUser = ProviderUser();
    await providerUser.open(tableUser);
    final user = await providerUser.getUser();
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }
}
