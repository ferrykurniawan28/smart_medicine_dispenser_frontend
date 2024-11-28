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
    initializeApp();
    reminders = CalendarController().getNextReminders(5);
    super.onInit();
  }

  Future<void> initializeApp() async {
    await providerUser.open(tableUser);
    user = await providerUser.getUser();
    update();
  }

  Future<void> refreshHome() async {
    reminders = CalendarController().getNextReminders(5);
    update();
  }
}
