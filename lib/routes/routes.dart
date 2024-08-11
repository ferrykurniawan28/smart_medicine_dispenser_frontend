import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/dashboard/views/dashboard.dart';
import 'package:smart_dispencer/presentation/home/views/home.dart';
import 'package:smart_dispencer/presentation/initial/views/splash.dart';
import 'package:smart_dispencer/routes/pages_name.dart';

class PagesRoutes {
  static List<GetPage> routes = [
    GetPage(
      name: PagesName.splash,
      page: () => const Splash(),
    ),
    GetPage(
      name: PagesName.home,
      page: () => const Home(),
    ),
    GetPage(
      name: PagesName.dashboard,
      page: () => const Dashboard(),
    ),
  ];
}
