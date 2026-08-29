import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

abstract final class MessageNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized || !Platform.isAndroid) return;
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (_) {
        if (Get.key.currentState != null) {
          Get.toNamed('/whisper');
        }
      },
    );
    _initialized = true;
  }

  static Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return false;
    await initialize();
    return await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission() ??
        false;
  }

  static Future<void> showUnread({
    required int total,
    required int added,
  }) async {
    if (!Platform.isAndroid || added <= 0) return;
    await initialize();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'pilinova_messages',
        'PiliNova 消息',
        channelDescription: '回复、私信、@、点赞和系统消息通知',
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.message,
      ),
    );
    await _plugin.show(
      20260723,
      '收到 $added 条新消息',
      '当前共有 $total 条未读消息',
      details,
      payload: '/whisper',
    );
  }
}
