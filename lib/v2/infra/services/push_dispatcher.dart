import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/notification.dart';

class PushDispatcher {
  static final PushDispatcher _instance = PushDispatcher._internal();
  factory PushDispatcher({GlobalKey<NavigatorState>? navigatorKey}) =>
      _instance;
  PushDispatcher._internal();

  GlobalKey<NavigatorState>? navigatorKey;

  final List<PushNotification> _recentNotifications = [];
  static const int maxRecentCount = 50;

  final ValueNotifier<int> pushCount = ValueNotifier<int>(0);

  bool _popupEnabled = true;

  bool get popupEnabled => _popupEnabled;
  set popupEnabled(bool value) {
    _popupEnabled = value;
  }

  void dispatch(BuildContext context, PushNotification notification) {
    _recentNotifications.insert(0, notification);
    if (_recentNotifications.length > maxRecentCount) {
      _recentNotifications.removeLast();
    }

    pushCount.value++;

    if (!_popupEnabled) {
      return;
    }

    if (PushCategory.isHomework(notification.category.activeType)) {
      _showHomeworkDialog(context, notification);
    } else if (notification.isGroupSign) {
      _showGroupSignDialog(context, notification);
    } else if (PushCategory.isSignIn(notification.category.activeType)) {
      _showSignInDialog(context, notification);
    } else {
      _showActivityDialog(context, notification);
    }
  }

  void _showHomeworkDialog(BuildContext context, PushNotification n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.assignment),
            const SizedBox(width: 8),
            const Expanded(child: Text('新作业')),
          ],
        ),
        content: Text(n.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('知道了'),
          ),
          if (n.hasHomeworkLink)
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _navigateToHomework(context, n);
              },
              child: const Text('去作答'),
            ),
        ],
      ),
    );
  }

  void _showActivityDialog(BuildContext context, PushNotification n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.event),
            const SizedBox(width: 8),
            const Expanded(child: Text('课程活动')),
          ],
        ),
        content: Text(n.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('知道了'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _navigateToActivity(context, n);
            },
            child: const Text('去查看'),
          ),
        ],
      ),
    );
  }

  void _showGroupSignDialog(BuildContext context, PushNotification n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.group_work),
            const SizedBox(width: 8),
            const Expanded(child: Text('群聊签到')),
          ],
        ),
        content: Text(n.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('知道了'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _navigateToActivity(context, n);
            },
            child: const Text('去签到'),
          ),
        ],
      ),
    );
  }

  void _showSignInDialog(BuildContext context, PushNotification n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle),
            const SizedBox(width: 8),
            Expanded(child: Text(n.category.label)),
          ],
        ),
        content: Text(n.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('知道了'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _navigateToSignIn(context, n);
            },
            child: const Text('去签到'),
          ),
        ],
      ),
    );
  }

  void _navigateToHomework(BuildContext context, PushNotification n) {
    if (n.courseId.isEmpty || n.homeworkId == null) {
      return;
    }
    final url =
        '/course/${n.courseId}/homework/${n.homeworkId}'
        '?classId=${n.classId}'
        '&cpi=${n.cpi}'
        '${n.homeworkUrl != null ? '&taskUrl=${Uri.encodeComponent(n.homeworkUrl!)}' : ''}';
    if (navigatorKey?.currentContext != null) {
      navigatorKey!.currentContext!.push(url);
    } else {
      context.push(url);
    }
  }

  void _navigateToActivity(BuildContext context, PushNotification n) {
    if (n.courseId.isEmpty) {
      return;
    }
    final url =
        '/course/${n.courseId}'
        '?classId=${n.classId}'
        '&cpi=${n.cpi}'
        '&name=${Uri.encodeComponent(n.courseName)}';
    if (navigatorKey?.currentContext != null) {
      navigatorKey!.currentContext!.push(url);
    } else {
      context.push(url);
    }
  }

  void _navigateToSignIn(BuildContext context, PushNotification n) {
    final activeId = n.rawData['aid']?.toString() ?? '';
    if (activeId.isEmpty) {
      return;
    }
    final url = '/signin/$activeId?courseId=${n.courseId}';
    if (navigatorKey?.currentContext != null) {
      navigatorKey!.currentContext!.push(url);
    } else {
      context.push(url);
    }
  }

  List<PushNotification> get recentNotifications =>
      List.unmodifiable(_recentNotifications);

  void clearRecent() => _recentNotifications.clear();
}
