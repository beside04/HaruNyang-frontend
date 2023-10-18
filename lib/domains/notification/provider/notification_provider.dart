import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/data/repository/dark_mode/dark_mode_repository_impl.dart';
import 'package:frontend/data/repository/push_messge/push_message_repository_impl.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:frontend/domains/main/model/main_state.dart';
import 'package:frontend/domains/notification/model/notification_state.dart';
import 'package:get/get.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(
    ref,
  ).._getToken();
});

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier(this.ref) : super(NotificationState());

  final Ref ref;

  String? token;

  Future<bool> initialize() async {
    // const AndroidNotificationChannel androidNotificationChannel =
    //     AndroidNotificationChannel(
    //   'high_importance_channel', // 임의의 id
    //   'High Importance Notifications', // 설정에 보일 채널명
    //   importance: Importance.max,
    // );
    //
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(androidNotificationChannel);

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
    );

    // FirebaseMessaging.onMessage.listen((RemoteMessage rm) async {
    //   message.value = rm;
    //   RemoteNotification? notification = rm.notification;
    //   AndroidNotification? android = rm.notification?.android;
    //
    //   // FlutterLocalNotificationsPlugin 초기화.
    //   await flutterLocalNotificationsPlugin.initialize(
    //     const InitializationSettings(
    //       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    //       iOS: DarwinInitializationSettings(),
    //     ),
    //   );
    //
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //       0,
    //       notification.title,
    //       notification.body,
    //       const NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           'high_importance_channel', // 임의의 id
    //           'High Importance Notifications', // 설정에 보일 채널명
    //         ),
    //       ),
    //     );
    //   }
    // });

    return true;
  }

  Future<void> _getToken() async {
    try {
      // token = await _messaging.getToken();
      // if (kDebugMode) {
      //   print("notification token:$token");
      // }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
