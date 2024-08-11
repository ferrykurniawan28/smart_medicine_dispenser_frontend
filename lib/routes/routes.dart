import 'package:get/get.dart';
import 'package:smart_dispencer/application/bindings/dashboardbinding.dart';
import 'package:smart_dispencer/application/bindings/homebinding.dart';
import 'package:smart_dispencer/application/bindings/splashbinding.dart';
import 'package:smart_dispencer/presentation/dashboard/views/dashboard.dart';
import 'package:smart_dispencer/presentation/home/views/home.dart';
import 'package:smart_dispencer/presentation/initial/views/auth.dart';
import 'package:smart_dispencer/presentation/initial/views/splash.dart';
import 'package:smart_dispencer/routes/pages_name.dart';

class PagesRoutes {
  static List<GetPage> routes = [
    GetPage(
      name: PagesName.splash,
      page: () => const Splash(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: PagesName.auth,
      page: () => const Auth(),
    ),
    GetPage(
      name: PagesName.home,
      page: () => const Home(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: PagesName.dashboard,
      page: () => const Dashboard(),
      binding: DashboardBinding(),
    ),
  ];
}
