import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/views/home.dart';
import 'package:smart_dispencer/routes/pages_name.dart';

class PagesRoutes {
  static List<GetPage> routes = [
    GetPage(
      name: PagesName.home,
      page: () => const Home(),
    ),
  ];
}