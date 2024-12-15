import 'package:get/get.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:smart_dispencer/data/models/device.dart';
import 'package:smart_dispencer/data/models/reminder.dart';
import 'package:smart_dispencer/data/models/user.dart';
import 'package:smart_dispencer/data/services/deviceservice.dart';
import 'package:smart_dispencer/presentation/calendar/controllers/calendarcontroller.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  final providerUser = ProviderUser();
  List<MedicineReminder> reminders = [];
  User? user;
  double? temperature;

  @override
  void onInit() async {
    await initializeApp();

    if (Get.find<Devicecontroller>().device != null) {
      getDeviceTemperature();
    }

    super.onInit();
  }

  Future<void> initializeApp() async {
    isLoading.value = true;
    await providerUser.open(tableUser);
    user = await providerUser.getUser();
    isLoading.value = false;
    update();
  }

  void getDeviceTemperature() async {
    ApiResponse apiResponse = ApiResponse();
    apiResponse = await fetchDeviceTemperature(
        Get.find<HomeController>().user!.id.toString());

    if (apiResponse.error != null) {
      Get.snackbar('Error', apiResponse.error!);
    } else {
      temperature = (apiResponse.data as Devices).temperature;
      update();
    }
  }

  // reminders setter
  void setReminders(List<MedicineReminder> reminders) {
    this.reminders = reminders;
    update();
  }

  Future<void> refreshHome() async {
    isLoading.value = true;
    Get.find<CalendarController>().get5reminders();
    isLoading.value = false;
    update();
  }
}
