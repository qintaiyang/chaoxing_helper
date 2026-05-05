import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/push_notification.dart';

class PushDispatcher {
  final GlobalKey<NavigatorState> navigatorKey;

  final List<PushNotification> _recentNotifications = [];
  static const int maxRecentCount = 50;

  final ValueNotifier<int> pushCount = ValueNotifier<int>(0);

  PushDispatcher({required this.navigatorKey});

  void dispatch(BuildContext context, PushNotification notification) {
    _recentNotifications.insert(0, notification);
    if (_recentNotifications.length > maxRecentCount) {
      _recentNotifications.removeLast();
    }

    pushCount.value++;

    debugPrint(
      '[PushDispatcher] ${notification.channel.label}: ${notification.title}',
    );

    if (PushCategory.isHomework(notification.category.activeType)) {
      _showHomeworkDialog(context, notification);
    } else if (notification.isGroupSign) {
      _showGroupSignDialog(context, notification);
    } else if (notification.category == PushCategory.signIn ||
        notification.category == PushCategory.scheduledSignIn) {
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
            Icon(n.category.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Expanded(child: Text('新作业')),
          ],
        ),
        content: Text(n.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              '知道了',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
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
            Icon(n.category.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Expanded(child: Text('课程活动')),
          ],
        ),
        content: Text(n.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              '知道了',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
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
            Icon(n.category.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Expanded(child: Text('群聊签到')),
          ],
        ),
        content: Text(n.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              '知道了',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
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
            Icon(n.category.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(n.category.label)),
          ],
        ),
        content: Text(n.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              '知道了',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
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
      debugPrint('[PushDispatcher] 缺少作业参数，无法导航');
      return;
    }
    final url =
        '/course/${n.courseId}/homework/${n.homeworkId}'
        '?classId=${n.classId}'
        '&cpi=${n.cpi}'
        '${n.homeworkUrl != null ? '&taskUrl=${Uri.encodeComponent(n.homeworkUrl!)}' : ''}';
    context.push(url);
    debugPrint(
      '[PushDispatcher] 导航到作业页面: courseId=${n.courseId}, workId=${n.homeworkId}',
    );
  }

  void _navigateToActivity(BuildContext context, PushNotification n) {
    if (n.courseId.isEmpty) {
      debugPrint('[PushDispatcher] 缺少课程ID，无法导航');
      return;
    }
    final url =
        '/course/${n.courseId}'
        '?classId=${n.classId}'
        '&cpi=${n.cpi}'
        '&name=${Uri.encodeComponent(n.courseName)}';
    context.push(url);
    debugPrint('[PushDispatcher] 导航到课程详情: ${n.courseId}');
  }

  void _navigateToSignIn(BuildContext context, PushNotification n) {
    final activeId = n.rawData['aid']?.toString() ?? '';
    if (activeId.isEmpty) {
      debugPrint('[PushDispatcher] 缺少签到ID，无法导航');
      return;
    }
    final url = '/signin/$activeId?courseId=${n.courseId}';
    context.push(url);
    debugPrint('[PushDispatcher] 导航到签到页面: activeId=$activeId');
  }

  List<PushNotification> get recentNotifications =>
      List.unmodifiable(_recentNotifications);

  void clearRecent() => _recentNotifications.clear();
}
