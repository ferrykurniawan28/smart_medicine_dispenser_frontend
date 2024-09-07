import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/initial/controller/signupcontroller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}
