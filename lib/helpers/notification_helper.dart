import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
 
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationHelper {
  // related to notification handling here in the future.
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> init() async {
    // Initialize notification settings, permissions, etc.
    // This is where you would set up the FlutterLocalNotificationsPlugin
    // and request permissions if necessary.
    //initialize time zones if needed
    tz.initializeTimeZones();
    // setLocalLocation(getLocation('Asia/Aden'));

    const androidSittings = AndroidInitializationSettings('@mipmap/app_icon');
    const DarwinInitializationSettings iosSittings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSittings,
      iOS: iosSittings,
      windows: WindowsInitializationSettings(appName: "molahadaty", appUserModelId: "my_notes.molahadaty", guid: "08733248-07bf-4a14-a957-e87de9196efd")
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,

     
    );
  }

  Future<void> addNoteAlarm(
    
    int id,
    String title,
    String body,
    DateTime? zone,
  ) async {
    int hours = zone!.hour;
    int munits = zone.minute;
    hours -= DateTime.now().hour;
    munits -= DateTime.now().minute;
    if (munits < 0) munits = 0;
    if (hours < 0) hours = 0;
    //check if notifcations are enabled
    final bool? areEnabled = await areNotificationsEnabled();
    //if not enabled, request permissions
    if (areEnabled == false) {
      final bool? granted = await requestPermissions();
      if (granted == false) {
        print('Notifications permission denied');
        return;
      }
    }

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      ' note_alarm_channel_id',
      'note_alarm',
      channelDescription: body,
      icon: '@mipmap/app_icon',
      sound: RawResourceAndroidNotificationSound('alrm'),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/app_icon'),
      importance: Importance.max,
      priority: Priority.high,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    // TZDateTime tim = DateTime.now().add(Duration(seconds: 20));
     NotificationDetails platformChannelSpecifics =
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
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.alarmClock);
  
  }

  void notificationTapBackground(NotificationResponse details) {

  }

  Future<bool?> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await androidImplementation?.requestNotificationsPermission();
      return granted;
    }
    return false;
  }

  // Check if notifications are enabled (Android only)
  Future<bool?> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      return await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
    }
    // For iOS and other platforms, assume notifications are enabled
    if (Platform.isIOS || Platform.isMacOS) {
      return true; // Assume enabled for iOS and macOS
    }
    return true; // Assume en abled for other platforms
  }

  Future selectNotification(String payload) async {
    // Handle notification tapped logic here
  }
  //cancel notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  //cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
 