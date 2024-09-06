import 'package:get/get.dart';

class Dashboardcontroller extends GetxController {
  RxList<String> dayList = <String>[].obs;

  @override
  void onInit() {
    getDay();
    super.onInit();
  }

  void getDay() {
    // add the last 5 days from today to the list
    for (int i = 0; i < 5; i++) {
      dayList.add(DateTime.now().subtract(Duration(days: i)).toString());
    }
  }
}
