import 'dart:async';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../../domain/entities/push_notification.dart';
import 'notification_service.dart';
import 'push_dispatcher.dart';
import 'dnd_service.dart';
import 'member_name_cache.dart';

class HomeworkPushEvent {
  final String courseId;
  final String classId;
  final String cpi;
  final String title;
  final String courseName;

  HomeworkPushEvent({
    required this.courseId,
    required this.classId,
    required this.cpi,
    required this.title,
    required this.courseName,
  });
}

class ImService {
  static const _appKey = 'cx-dev#cxstudy';

  final GlobalKey<NavigatorState> navigatorKey;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isAppInForeground = true;

  String? _savedUserName;
  String? _savedPassword;

  Timer? _keepAliveTimer;
  int _reconnectAttempts = 0;
  static const _maxReconnectAttempts = 10;

  final Map<String, String> _groupNames = {};

  final StreamController<HomeworkPushEvent> _homeworkPushController =
      StreamController<HomeworkPushEvent>.broadcast();
  Stream<HomeworkPushEvent> get onHomeworkPush =>
      _homeworkPushController.stream;

  final StreamController<Map<String, dynamic>> _activePushController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onActivePush => _activePushController.stream;

  final StreamController<EMMessage> _newMessageController =
      StreamController<EMMessage>.broadcast();
  Stream<EMMessage> get onNewMessage => _newMessageController.stream;

  ImService({required this.navigatorKey});

  void setAppForeground(bool isForeground) {
    _isAppInForeground = isForeground;
    debugPrint('[ImService] 应用前台状态: $isForeground');
    if (isForeground) {
      _reconnectAttempts = 0;
      if (_isLoggedIn) {
        _startKeepAliveCheck();
      }
    } else {
      if (_isLoggedIn) {
        _startKeepAliveCheck();
      }
    }
  }

  Future<void> initialize() async {
    try {
      final options = EMOptions.withAppKey(_appKey, osType: 2);
      await EMClient.getInstance.init(options);

      EMClient.getInstance.addConnectionEventHandler(
        'easemob_conn_handler',
        EMConnectionEventHandler(
          onConnected: () {
            _isLoggedIn = true;
            _reconnectAttempts = 0;
            debugPrint('[ImService] 已连接到环信服务器');
            Future.delayed(const Duration(seconds: 2), () {
              _ensureGroupNameLoaded('');
            });
          },
          onDisconnected: () {
            debugPrint('[ImService] 断开连接');
            _attemptReconnect();
          },
          onUserDidLoginFromOtherDevice: (info) {
            _isLoggedIn = false;
            _stopKeepAliveTimer();
            _showKickedDialog(info);
          },
          onTokenDidExpire: () {
            debugPrint('[ImService] Token已过期');
            _isLoggedIn = false;
            _stopKeepAliveTimer();
          },
        ),
      );

      EMClient.getInstance.chatManager.addEventHandler(
        'easemob_msg_handler',
        EMChatEventHandler(
          onMessagesReceived: (List<EMMessage> messages) {
            debugPrint('收到 ${messages.length} 条新消息');
            for (var message in messages) {
              _handleMessage(message);
            }
          },
          onCmdMessagesReceived: (List<EMMessage> messages) {
            debugPrint('收到 ${messages.length} 条命令消息');
          },
          onMessagesRead: (List<EMMessage> messages) {
            debugPrint('消息已读回执: ${messages.length} 条');
          },
          onGroupMessageRead: (List<EMGroupMessageAck> acks) {
            debugPrint('群组消息已读: ${acks.length} 条');
          },
          onMessagesDelivered: (List<EMMessage> messages) {
            debugPrint('消息送达回执: ${messages.length} 条');
          },
        ),
      );

      _isLoggedIn = await EMClient.getInstance.isLoginBefore();
    } catch (e) {
      debugPrint('初始化错误: $e');
      rethrow;
    }
  }

  Future<void> login(String userName, String password) async {
    try {
      _savedUserName = userName;
      _savedPassword = password;
      final isAlreadyLoggedIn = await EMClient.getInstance.isLoginBefore();
      if (isAlreadyLoggedIn) {
        final currentUser = EMClient.getInstance.currentUserId;
        if (currentUser == userName) {
          _isLoggedIn = true;
          _reconnectAttempts = 0;
          debugPrint('Easemob已登录，无需重复登录: $userName');
          _onLoginSuccess();
          return;
        }
        await EMClient.getInstance.logout(true);
      }
      await EMClient.getInstance.loginWithPassword(userName, password);
      _isLoggedIn = true;
      _reconnectAttempts = 0;
      _onLoginSuccess();
    } on EMError catch (e) {
      if (e.code == 200 || e.code == 218) {
        _isLoggedIn = true;
        _reconnectAttempts = 0;
        debugPrint('Easemob已登录(错误码${e.code}): ${e.description}');
        _onLoginSuccess();
      } else {
        debugPrint('Easemob登录失败: $e');
      }
    } catch (e) {
      debugPrint('Easemob登录失败: $e');
    }
  }

  void _onLoginSuccess() {
    NotificationService().startImForegroundService().catchError((e) {
      debugPrint('启动IM前台保活服务失败: $e');
    });
    DndService().loadFromStorage();
  }

  Future<void> loginCurrentUser({
    required String sessionId,
    required String userName,
    required String password,
  }) async {
    await login(userName, password);
  }

  Future<void> refreshGroupInfo() async {
    debugPrint('[ImService] 手动刷新群组信息...');
    _groupNames.clear();
    await _ensureGroupNameLoaded('');
  }

  Future<void> logout() async {
    try {
      _stopKeepAliveTimer();
      _savedUserName = null;
      _savedPassword = null;
      _groupNames.clear();
      await EMClient.getInstance.logout(true);
      _isLoggedIn = false;
      _reconnectAttempts = 0;
    } catch (e) {
      debugPrint('Easemob退出失败: $e');
    }
  }

  void _handleMessage(EMMessage message) {
    final context = navigatorKey.currentContext;

    debugPrint(
      '收到消息: type=${message.body.type}, from=${message.from}, to=${message.to}',
    );

    _pushToNewMessageStream(message);

    if (message.attributes != null) {
      final attachment = message.attributes!['attachment'];
      debugPrint('消息attributes keys: ${message.attributes!.keys.join(', ')}');
      if (attachment != null) {
        debugPrint('attachment类型: ${attachment.runtimeType}');
        if (attachment is Map) {
          debugPrint('attachment keys: ${attachment.keys.join(', ')}');
        }
        if (attachment.containsKey('att_chat_course')) {
          final activeInfo = attachment['att_chat_course'];
          debugPrint('att_chat_course内容: $activeInfo');
          _handleCourseActivityMessage(message, activeInfo, context);
          return;
        }
        if (attachment.containsKey('att_homework')) {
          final homeworkInfo = attachment['att_homework'];
          debugPrint('att_homework内容: $homeworkInfo');
          _handleHomeworkMessage(message, homeworkInfo, context);
          return;
        }
        if (attachment.containsKey('att_group_sign')) {
          final groupSignInfo = attachment['att_group_sign'];
          debugPrint('att_group_sign内容: $groupSignInfo');
          _handleGroupSignInMessage(message, groupSignInfo, context);
          return;
        }
        if (attachment.containsKey('text')) {
          _handleTextMessage(message, attachment['text'], context);
          return;
        }
      }
    }

    final body = message.body;
    if (body is EMTextMessageBody) {
      final text = body.content;
      if (text.isNotEmpty) {
        _handleTextMessage(message, text, context);
        return;
      }
    }

    debugPrint('未处理的消息类型: ${message.body.type}');
    debugPrint('消息完整JSON: ${message.toJson()}');
  }

  void _handleCourseActivityMessage(
    EMMessage message,
    dynamic activeInfo,
    BuildContext? context,
  ) {
    final notification = PushNotification.fromCourseActivity(
      activeInfo as Map<String, dynamic>,
    );

    _activePushController.add({
      'activeType': notification.category.activeType,
      'courseId': notification.courseId,
      'classId': notification.classId,
      'cpi': notification.cpi,
      'courseName': notification.courseName,
    });

    if (_isAppInForeground) {
      if (context != null) {
        PushDispatcher(
          navigatorKey: navigatorKey,
        ).dispatch(context, notification);
      }
    } else {
      NotificationService().showPushNotification(notification: notification);
    }
  }

  void _handleHomeworkMessage(
    EMMessage message,
    dynamic homeworkInfo,
    BuildContext? context,
  ) {
    final notification = PushNotification.fromHomework(
      homeworkInfo as Map<String, dynamic>,
    );

    _homeworkPushController.add(
      HomeworkPushEvent(
        courseId: notification.courseId,
        classId: notification.classId,
        cpi: notification.cpi,
        title: notification.title,
        courseName: notification.courseName,
      ),
    );

    if (_isAppInForeground) {
      if (context != null) {
        PushDispatcher(
          navigatorKey: navigatorKey,
        ).dispatch(context, notification);
      }
    } else {
      NotificationService().showPushNotification(notification: notification);
    }
  }

  void _handleGroupSignInMessage(
    EMMessage message,
    dynamic groupSignInInfo,
    BuildContext? context,
  ) {
    final notification = PushNotification.fromGroupSign(
      groupSignInInfo as Map<String, dynamic>,
    );

    if (_isAppInForeground) {
      if (context != null) {
        PushDispatcher(
          navigatorKey: navigatorKey,
        ).dispatch(context, notification);
      }
    } else {
      NotificationService().showPushNotification(notification: notification);
    }
  }

  void _handleTextMessage(
    EMMessage message,
    String text,
    BuildContext? context,
  ) {
    debugPrint('收到文本消息: $text, from=${message.from}, to=${message.to}');

    if (message.chatType == ChatType.GroupChat) {
      final convId = message.conversationId ?? message.to ?? '';
      final senderId = message.from ?? '未知';
      final isMe = message.from == EMClient.getInstance.currentUserId;
      debugPrint(
        '[ImNotify] 通知判断: isMe=$isMe, isForeground=$_isAppInForeground, groupId=$convId',
      );
      if (!isMe && !_isAppInForeground) {
        if (DndService().isDnd(convId)) {
          debugPrint('[ImNotify] 免打扰模式，跳过通知: groupId=$convId');
        } else {
          _showNotificationWithBestName(convId, senderId, text, message);
        }
      } else if (isMe) {
        debugPrint('[ImNotify] 跳过通知: 自己的消息');
      } else {
        debugPrint('[ImNotify] 跳过通知: 应用在前台');
      }
    }
  }

  void _showNotificationWithBestName(
    String groupId,
    String senderId,
    String text, [
    EMMessage? message,
  ]) {
    final content = text.length > 100 ? '${text.substring(0, 100)}...' : text;

    final cachedName = MemberNameCache().get(senderId);
    final cachedGroupName = _groupNames[groupId];

    String? pushGroupName;
    if (message?.attributes != null) {
      final apnsExt = message!.attributes!['em_apns_ext'];
      if (apnsExt is Map) {
        pushGroupName = apnsExt['em_push_title']?.toString();
      }
    }

    final bestGroupName = cachedGroupName?.isNotEmpty == true
        ? cachedGroupName
        : pushGroupName;
    final bestSenderName = cachedName ?? senderId;

    if (bestGroupName != null && bestGroupName.isNotEmpty) {
      _groupNames[groupId] = bestGroupName;
    }

    _showNotification(
      groupId,
      bestGroupName ?? groupId,
      bestSenderName,
      content,
    );

    if (cachedName == null) {
      _resolveNameAsync(groupId, senderId, content);
    }
  }

  Future<void> _resolveNameAsync(
    String groupId,
    String senderId,
    String content,
  ) async {
    final cachedName = MemberNameCache().get(senderId);
    if (cachedName != null) return;

    final results = await Future.wait([
      _resolveSenderFromGroupAttributes(groupId, senderId),
    ]);

    final resolvedName = results[0];
    if (resolvedName != null) {
      MemberNameCache().set(senderId, resolvedName);
      MemberNameCache().saveToStorage();
      _ensureGroupNameLoaded(groupId);
      _updateNotification(groupId, senderId, resolvedName, content, null);
    }
  }

  Future<String?> _resolveSenderFromGroupAttributes(
    String groupId,
    String senderId,
  ) async {
    try {
      _ensureGroupNameLoaded(groupId);

      final attrs = await EMClient.getInstance.groupManager
          .fetchMembersAttributes(
            groupId: groupId,
            userIds: [senderId],
            keys: ['displayName'],
          );

      if (attrs.containsKey(senderId)) {
        final attrMap = attrs[senderId]!;
        final displayName = attrMap['displayName'];
        if (displayName is String &&
            displayName.isNotEmpty &&
            displayName != senderId) {
          debugPrint('[ImService] 从群组属性解析到: $senderId -> $displayName');
          return displayName;
        }
      }
    } catch (e) {
      debugPrint('[ImService] 从群组属性解析昵称失败: $e');
    }
    return null;
  }

  Future<void> _ensureGroupNameLoaded(String groupId) async {
    if (_groupNames.containsKey(groupId)) return;
    try {
      final groups = await EMClient.getInstance.groupManager.getJoinedGroups();
      for (final g in groups) {
        final name = g.groupName;
        if (name != null && name.isNotEmpty) {
          _groupNames[g.groupId] = name;
        }
      }
    } catch (e) {
      debugPrint('[ImService] 加载群组名称失败: $e');
    }
  }

  Future<void> _updateNotification(
    String groupId,
    String senderId,
    String senderName,
    String content,
    String? groupName,
  ) async {
    final resolvedGroupName = groupName ?? _groupNames[groupId] ?? groupId;
    _showNotification(groupId, resolvedGroupName, senderName, content);
  }

  void _showNotification(
    String groupId,
    String groupName,
    String senderName,
    String text,
  ) {
    NotificationService().showImMessage(
      groupId: groupId,
      groupName: groupName,
      senderName: senderName,
      content: text,
    );
  }

  void _pushToNewMessageStream(EMMessage message) {
    if (message.chatType == ChatType.GroupChat) {
      _newMessageController.add(message);
    } else if (message.chatType == ChatType.Chat) {
      _newMessageController.add(message);
    }
  }

  void _stopKeepAliveTimer() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
  }

  void _startKeepAliveCheck() {
    _stopKeepAliveTimer();
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 30), (
      timer,
    ) async {
      try {
        final isConnected = await EMClient.getInstance.isConnected();
        debugPrint(
          '[ImService] 心跳保活检测: SDK连接状态=$isConnected, 登录状态=$_isLoggedIn',
        );
        if (!isConnected) {
          debugPrint('[ImService] SDK连接断开，触发重连');
          _attemptReconnect();
        }
      } catch (e) {
        debugPrint('[ImService] 心跳保活检测异常: $e');
        _attemptReconnect();
      }
    });
  }

  void onForegroundServiceKeepAlive() {
    debugPrint('[ImService] 前台服务心跳触发，检查连接...');
    if (_savedUserName == null || _savedPassword == null) return;
    _checkConnectionAndReconnect();
  }

  Future<void> _checkConnectionAndReconnect() async {
    try {
      final isConnected = await EMClient.getInstance.isConnected();
      debugPrint('[ImService] 前台服务触发连接检查: SDK连接=$isConnected, 登录=$_isLoggedIn');
      if (!isConnected) {
        _reconnectAttempts = 0;
        _attemptReconnect();
      }
    } catch (e) {
      debugPrint('[ImService] 连接检查异常: $e');
      _reconnectAttempts = 0;
      _attemptReconnect();
    }
  }

  void _attemptReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('[ImService] 达到最大重连次数 $_maxReconnectAttempts，停止重连');
      return;
    }
    if (_savedUserName == null || _savedPassword == null) {
      debugPrint('[ImService] 未保存登录凭据，无法重连');
      return;
    }
    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 3);
    debugPrint(
      '[ImService] ${delay.inSeconds}秒后尝试第$_reconnectAttempts次重连... (前台=$_isAppInForeground)',
    );
    Timer(delay, () async {
      try {
        await login(_savedUserName!, _savedPassword!);
      } catch (e) {
        debugPrint('[ImService] 自动重连失败: $e');
      }
    });
  }

  Future<void> checkAndReconnect() async {
    try {
      final isConnected = await EMClient.getInstance.isConnected();
      if (!isConnected && _savedUserName != null && _savedPassword != null) {
        debugPrint('[ImService] IM连接已断开，尝试重连...');
        _reconnectAttempts = 0;
        _attemptReconnect();
      }
    } catch (e) {
      debugPrint('[ImService] 检查连接状态失败: $e');
    }
  }

  void _showKickedDialog(LoginExtensionInfo info) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: SingleChildScrollView(
          child: Text(
            '当前学习通IM账号在${info.deviceName}登录',
            style: const TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              if (_savedUserName != null && _savedPassword != null) {
                login(_savedUserName!, _savedPassword!);
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('重新登录'),
          ),
        ],
      ),
    );
  }

  void dispose() {
    _keepAliveTimer?.cancel();
    _homeworkPushController.close();
    _activePushController.close();
    _newMessageController.close();
  }
}
