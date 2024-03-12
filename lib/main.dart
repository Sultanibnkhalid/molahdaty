import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/helpers/db_helper.dart';
import 'package:my_notes/helpers/notification_helper.dart';
import 'package:my_notes/layouts/main_layout.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:my_notes/shared/observer.dart';
import 'package:toast/toast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper().init();
  // AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('my_notes');
  // InitializationSettings initializationSettings =
  //     InitializationSettings(android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  // int c =
  await DBHelper.createDB();
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MaterialApp(
      title: 'sultan\'s notes',
      theme: ThemeData(
        useMaterial3: true,

        //  Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber.shade400,
          // TRY THIS: Change to "Brightness.light"
          //           and see that all colors change
          //           to better contrast a light background.
          brightness: Brightness.light,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'Whisper',
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            // TRY THIS: Change one of the GoogleFonts
            //           to "lato", "poppins", or "lora".
            //           The title uses "titleLarge"
            //           and the middle text uses "bodyMedium".
            // titleLarge: GoogleFonts.oswald(
            //   fontSize: 15,
            //   fontStyle: FontStyle.normal,
            // ),
            bodyMedium: TextStyle(
              color: Colors.black,
              fontFamily: 'ElMessiri',
              fontWeight: FontWeight.w400,
              fontSize: 30,
            ),
            displaySmall: TextStyle(
              color: Colors.black,
              fontFamily: 'ElMessiri',
              fontWeight: FontWeight.w300,
            )),
      ),
      home: HomeScreen(),
    );
  }


}
