import 'package:get/get.dart';
import 'package:smart_dispencer/data/models/user.dart';

class HomeController extends GetxController {
  final providerUser = ProviderUser();
  User? user;

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  void getUser() async {
    await providerUser.open(tableUser);
    user = await providerUser.getUser();
    update();
    print(user?.name);
  }
}
