import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:molahdaty/helpers/db_helper.dart';
import 'package:molahdaty/helpers/notification_helper.dart';
import 'package:molahdaty/layouts/main_layout.dart';
import 'package:molahdaty/shared/themes.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
      NotificationHelper().init(),
      EasyLocalization.ensureInitialized(),
  ]);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      saveLocale: true,
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );

  // Defer non-critical initializations to after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      await DBHelper.initialize();
      // Bloc.observer = MyBlocObserver();
    } catch (e) {
      debugPrint('Deferred initialization error: $e');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'molahdaty',
      theme: lightTheme,
      home: const  HomeScreen());
  }
}
 
 
