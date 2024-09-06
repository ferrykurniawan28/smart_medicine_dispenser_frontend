import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/dashboard/controllers/dashboardcontroller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Dashboardcontroller>(() => Dashboardcontroller());
  }
}
