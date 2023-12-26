import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/domain/repository/push_message/push_message_repository.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PushMessageUseCase {
  final PushMessageRepository pushMessagePermissionRepository;

  PushMessageUseCase({
    required this.pushMessagePermissionRepository,
  });

  Future<String?> getIsPushMessagePermission() async {
    return await pushMessagePermissionRepository.getIsPushMessagePermission();
  }

  Future<void> setPushMessagePermission(String isPushMessagePermission) async {
    await pushMessagePermissionRepository.setPushMessagePermission(isPushMessagePermission);
  }

  Future<void> deletePushMessagePermissionData() async {
    await pushMessagePermissionRepository.deletePushMessagePermissionData();
  }

  Future<String?> getIsMarketingConsentAgree() async {
    return await pushMessagePermissionRepository.getIsMarketingConsentAgree();
  }

  Future<void> setMarketingConsentAgree(String isMarketingConsentAgree) async {
    await pushMessagePermissionRepository.setMarketingConsentAgree(isMarketingConsentAgree);
  }

  Future<void> deleteMarketingConsentAgree() async {
    await pushMessagePermissionRepository.deleteMarketingConsentAgree();
  }

  Future<String?> getPushMessageTime() async {
    return await pushMessagePermissionRepository.getPushMessageTime();
  }

  Future<void> setPushMessageTime(String isPushMessageTime) async {
    await pushMessagePermissionRepository.setPushMessageTime(isPushMessageTime);
  }

  Future<void> deletePushMessageTime() async {
    await pushMessagePermissionRepository.deletePushMessageTime();
  }

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future dailyAtTimeNotification(Time alarmTime) async {
    const notiTitle = '하루냥은 당신을 기다려요🐱';
    const notiDesc = '오늘은 어떤 하루였나요? 오늘의 기분을 일기로 남기면, 하루냥이 따듯한 쪽지를 건네줄 거예요.';

    final result = Platform.isAndroid
        ? await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission()
        : await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions();

    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        'id',
        notiTitle,
        importance: Importance.max,
        priority: Priority.max,
        icon: "@mipmap/ic_launcher",
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    if (result != null) {
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.deleteNotificationChannelGroup('id');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        notiTitle,
        notiDesc,
        _setNotiTime(alarmTime),
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  tz.TZDateTime _setNotiTime(Time alarmTime) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, alarmTime.hour, alarmTime.minute, 0);
    scheduledDate = scheduledDate.add(const Duration(days: 1));
    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
