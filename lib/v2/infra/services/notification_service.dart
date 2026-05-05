import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../../domain/entities/push_notification.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  static const String _imChannelId = 'im_messages';
  static const String _imChannelName = '即时消息';
  static const String _imChannelDesc = '接收群聊消息和课程活动通知';

  static const String _pushChannelId = 'course_push';
  static const String _pushChannelName = '课程推送';
  static const String _pushChannelDesc = '作业、签到、活动等课程推送通知';

  static const String _foregroundChannelId = 'im_background';
  static const String _foregroundChannelName = '后台消息服务';
  static const String _foregroundChannelDesc = '保持IM连接以接收后台消息';

  static const int _imNotificationBaseId = 1000;
  static const int _pushNotificationBaseId = 2000;

  final Map<String, int> _groupNotificationIds = {};
  int _nextPushId = _pushNotificationBaseId;

  Function(NotificationResponse)? _onNotificationTap;

  Future<void> initialize({
    Function(NotificationResponse)? onNotificationTap,
  }) async {
    if (_initialized) return;

    _onNotificationTap = onNotificationTap;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onBackgroundNotificationResponse,
    );

    if (Platform.isAndroid) {
      await _createAndroidNotificationChannels();
    }

    _initialized = true;
    debugPrint('[NotificationService] 初始化完成');
  }

  Future<void> _createAndroidNotificationChannels() async {
    final plugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (plugin == null) return;

    await plugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _imChannelId,
        _imChannelName,
        description: _imChannelDesc,
        importance: Importance.high,
      ),
    );

    await plugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _pushChannelId,
        _pushChannelName,
        description: _pushChannelDesc,
        importance: Importance.max,
      ),
    );

    await plugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _foregroundChannelId,
        _foregroundChannelName,
        description: _foregroundChannelDesc,
        importance: Importance.low,
      ),
    );

    debugPrint('[NotificationService] Android通知渠道创建完成');
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint(
      '[NotificationService] 通知点击: id=${response.id}, payload=${response.payload}',
    );
    _onNotificationTap?.call(response);
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final plugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (plugin == null) return false;
      return await plugin.requestNotificationsPermission() ?? false;
    }
    if (Platform.isIOS) {
      final plugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (plugin == null) return false;
      final result = await plugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return result ?? false;
    }
    return false;
  }

  Future<void> showImMessage({
    required String groupId,
    required String groupName,
    required String senderName,
    required String content,
    String? groupIcon,
  }) async {
    debugPrint(
      '[NotificationService] showImMessage: initialized=$_initialized, groupId=$groupId, sender=$senderName',
    );
    if (!_initialized) {
      debugPrint('[NotificationService] ⚠️ 未初始化，跳过通知');
      return;
    }

    final notificationId = _getGroupNotificationId(groupId);

    final androidDetails = AndroidNotificationDetails(
      _imChannelId,
      _imChannelName,
      channelDescription: _imChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      autoCancel: true,
      styleInformation: MessagingStyleInformation(
        Person(name: senderName),
        conversationTitle: groupName,
        groupConversation: true,
        messages: [Message(content, DateTime.now(), Person(name: senderName))],
      ),
      groupKey: 'im_group_$groupId',
      setAsGroupSummary: false,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payload = jsonEncode({
      'type': 'im_message',
      'groupId': groupId,
      'groupName': groupName,
    });

    await _plugin.show(
      notificationId,
      groupName,
      '$senderName: $content',
      details,
      payload: payload,
    );

    debugPrint(
      '[NotificationService] 显示IM消息通知: groupId=$groupId, sender=$senderName',
    );
  }

  Future<void> showPushNotification({
    required PushNotification notification,
  }) async {
    debugPrint(
      '[NotificationService] showPushNotification: initialized=$_initialized, title=${notification.title}',
    );
    if (!_initialized) return;

    final notificationId = _nextPushId++;
    if (_nextPushId > _pushNotificationBaseId + 999) {
      _nextPushId = _pushNotificationBaseId;
    }

    final androidDetails = AndroidNotificationDetails(
      _pushChannelId,
      _pushChannelName,
      channelDescription: _pushChannelDesc,
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
      autoCancel: true,
      styleInformation: BigTextStyleInformation(notification.content),
      color: const Color(0xFF4A80F0),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payload = jsonEncode({
      'type': 'push_notification',
      'channel': notification.channel.key,
      'category': notification.category.name,
      'courseId': notification.courseId,
      'classId': notification.classId,
      'cpi': notification.cpi,
      'title': notification.title,
      'hasHomeworkLink': notification.hasHomeworkLink,
      'homeworkUrl': notification.homeworkUrl,
      'homeworkId': notification.homeworkId,
    });

    await _plugin.show(
      notificationId,
      notification.title,
      notification.content,
      details,
      payload: payload,
    );

    debugPrint(
      '[NotificationService] 显示推送通知: ${notification.category.label} - ${notification.title}',
    );
  }

  Future<void> startImForegroundService() async {
    if (!_initialized) return;
    if (!Platform.isAndroid) return;

    if (await FlutterForegroundTask.isRunningService) {
      debugPrint('[NotificationService] IM后台保活服务已在运行');
      return;
    }

    debugPrint('[NotificationService] 启动IM后台保活服务');

    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    await FlutterForegroundTask.startService(
      notificationTitle: '课程助手',
      notificationText: '正在接收消息通知...',
      callback: imForegroundStartCallback,
    );

    debugPrint('[NotificationService] IM后台保活服务启动完成');
  }

  Future<void> stopImForegroundService() async {
    if (!Platform.isAndroid) return;
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }
    debugPrint('[NotificationService] 停止IM后台保活服务');
  }

  int _getGroupNotificationId(String groupId) {
    if (!_groupNotificationIds.containsKey(groupId)) {
      _groupNotificationIds[groupId] =
          _imNotificationBaseId + _groupNotificationIds.length;
      if (_groupNotificationIds.length > 999) {
        _groupNotificationIds.clear();
        _groupNotificationIds[groupId] = _imNotificationBaseId;
      }
    }
    return _groupNotificationIds[groupId]!;
  }

  Future<void> cancelGroupNotification(String groupId) async {
    final id = _groupNotificationIds[groupId];
    if (id != null) {
      await _plugin.cancel(id);
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}

@pragma('vm:entry-point')
void _onBackgroundNotificationResponse(NotificationResponse response) {
  debugPrint(
    '[NotificationService] 后台通知点击: id=${response.id}, payload=${response.payload}',
  );
}

@pragma('vm:entry-point')
void imForegroundStartCallback() {
  FlutterForegroundTask.setTaskHandler(ImKeepAliveTaskHandler());
}

class ImKeepAliveTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('[ImKeepAlive] 服务启动: starter=${starter.name}');
    FlutterForegroundTask.sendDataToMain('keepalive');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    FlutterForegroundTask.sendDataToMain('keepalive');
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    debugPrint('[ImKeepAlive] 服务销毁');
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
  }
}
