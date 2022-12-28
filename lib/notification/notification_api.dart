import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String>();
  static Future notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails("channel id", "channel name",
            importance: Importance.max));
  }

  static Future init({bool initSheduled = false}) async {
    final android = const AndroidInitializationSettings('@mipmap/ic_launcher');

    final settings = InitializationSettings(android: android);
    await _notification.initialize(
      settings,
    );
    if (initSheduled) {
      tz.initializeTimeZones();
      final locationname = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationname));
    }
  }

  // static Future showNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? playoad,
  // }) async {
  //   return _notification.show(id, title, body, await notificationDetails());
  // }

  static void showNotifi({
    int id = 0,
    String? title,
    String? body,
    String? playoad,
    required DateTime date,
  }) async {
    return _notification.zonedSchedule(id, title, body,
        tz.TZDateTime.from(date, tz.local), await notificationDetails(),
        payload: playoad,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static void showNotifiicationDaily({
    int id = 0,
    String? title,
    String? body,
    String? playoad,
    required DateTime date,
  }) async {
    return _notification.zonedSchedule(id, title, body,
        _schedule(const Time(8, 1, 01)), await notificationDetails(),
        payload: playoad,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static tz.TZDateTime _schedule(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }
}
