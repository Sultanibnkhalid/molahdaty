import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_notes/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationHelper {
  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    // );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse:
      //     (NotificationResponse notificationResponse) async {
      //   // ...
      // },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (details) {
        //handel notif..
      },
    );
    tz.initializeTimeZones();
  }

  Future selectNotification(String payload) async {
    //Handle notification tapped logic here
  }

  Future<void> addNoteAlarm(
    id,
    title,
    body,
    DateTime? zone,
  ) async {
    int hours = zone!.hour;
    int munits = zone.minute;
    hours -= DateTime.now().hour;
    munits -= DateTime.now().minute;
    if (munits < 0) munits = 0;
    if (hours < 0) hours = 0;

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'note_alarm',
      'note_alarm',
      channelDescription: 'This is a note alarm notification',
      icon: 'app_icon',
      sound: RawResourceAndroidNotificationSound('alrm1'),
      
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );
    // TZDateTime tim = DateTime.now().add(Duration(seconds: 20));
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    //set the Schedule
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(
          hours: hours,
          minutes: munits,
        )),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void notificationTapBackground(NotificationResponse details) {}
}
