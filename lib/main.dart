import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/application/bindings/splashbinding.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/routes/pages_name.dart';
import 'package:smart_dispencer/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await _requestNotificationPermission();

  await AwesomeNotifications().initialize(
    null, //TODO: Add your app icon
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: BrightnessMode.primary,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      )
    ],
    debug: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: message.notification?.title ?? 'No title',
      body: message.notification?.body ?? 'No body',
    ));
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: true,
    sound: true,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: SplashBinding(),
      initialRoute: PagesName.splash,
      getPages: PagesRoutes.routes,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await AwesomeNotifications().initialize(
  //   null,
  //   [
  //     NotificationChannel(
  //       channelKey: 'basic_channel',
  //       channelName: 'Basic Notifications',
  //       channelDescription: 'Notification channel for basic tests',
  //       defaultColor: BrightnessMode.primary,
  //       ledColor: Colors.white,
  //       importance: NotificationImportance.High,
  //     )
  //   ],
  //   debug: true,
  // );

  AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 10,
    channelKey: 'basic_channel',
    title: message.notification?.title ?? 'No title',
    body: message.notification?.body ?? 'No body',
  ));
}

Future<void> _requestNotificationPermission() async {
  final settings = await AwesomeNotifications().isNotificationAllowed();
  if (!settings) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
