import 'package:get/get.dart';
import 'package:smart_dispencer/application/bindings/bottomappbarbinding.dart';
import 'package:smart_dispencer/application/bindings/dashboardbinding.dart';
import 'package:smart_dispencer/application/bindings/signinbinding.dart';
import 'package:smart_dispencer/application/bindings/signupbinding.dart';
import 'package:smart_dispencer/application/bindings/splashbinding.dart';
import 'package:smart_dispencer/presentation/bottomapp_bar/views/bottomappbar.dart';
import 'package:smart_dispencer/presentation/dashboard/views/dashboard.dart';
import 'package:smart_dispencer/presentation/initial/views/auth.dart';
import 'package:smart_dispencer/presentation/initial/views/signin.dart';
import 'package:smart_dispencer/presentation/initial/views/signup.dart';
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
      name: PagesName.login,
      page: () => const Signin(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: PagesName.register,
      page: () => const Signup(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: PagesName.home,
      page: () => const Bottomappbar(),
      binding: BottomAppBarBinding(),
    ),
    GetPage(
      name: PagesName.dashboard,
      page: () => const Dashboard(),
      binding: DashboardBinding(),
    ),
  ];
}
