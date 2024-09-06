import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/initial/controller/signincontroller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}
