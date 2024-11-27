import 'package:get/get.dart';
import 'package:smart_dispencer/data/models/reminder.dart';
import 'package:smart_dispencer/data/models/user.dart';
import 'package:smart_dispencer/presentation/calendar/controllers/calendarcontroller.dart';

class HomeController extends GetxController {
  final providerUser = ProviderUser();
  List<MedicineReminder> reminders = [];
  User? user;

  @override
  void onInit() {
    reminders = CalendarController().getNextReminders(5);
    getUser();
    super.onInit();
  }

  Future<void> refreshHome() async {
    reminders = CalendarController().getNextReminders(5);
    print(reminders.length);
    print(reminders);
    update();
  }

  void getUser() async {
    await providerUser.open(tableUser);
    user = await providerUser.getUser();
    update();
    print(user?.name);
  }
}
