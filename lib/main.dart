import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/application/bindings/splashbinding.dart';
import 'package:smart_dispencer/routes/pages_name.dart';
import 'package:smart_dispencer/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ,
      initialBinding: SplashBinding(),
      initialRoute: PagesName.splash,
      getPages: PagesRoutes.routes,
    );
  }
}
