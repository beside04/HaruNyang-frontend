import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushMessageViewModel extends GetxController {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future dailyAtTimeNotification(Time alarmTime) async {
    const notiTitle = '하루냥은 당신을 기다려요🐱';
    const notiDesc = '오늘은 어떤 하루였나요? 오늘의 기분을 일기로 남기면, 하루냥이 따듯한 한 마디를 건네줄 거예요.';

    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    var android = const AndroidNotificationDetails('id', notiTitle,
        importance: Importance.max, priority: Priority.max);
    var ios = const DarwinNotificationDetails();
    var detail = NotificationDetails(android: android, iOS: ios);

    if (result != null) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannelGroup('id');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        notiTitle,
        notiDesc,
        _setNotiTime(alarmTime),
        detail,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  tz.TZDateTime _setNotiTime(Time alarmTime) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        alarmTime.hour, alarmTime.minute, 0);
    scheduledDate = scheduledDate.add(const Duration(days: 1));
    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
