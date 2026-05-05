import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'infra/theme/theme_compiler.dart';
import 'infra/theme/theme_data.dart';
import 'presentation/routing/app_router.dart';
import 'presentation/providers/theme_provider.dart';

final GlobalKey<NavigatorState> v2NavigatorKey = GlobalKey<NavigatorState>();

void handleNotificationTap(NotificationResponse response) {
  final payload = response.payload;
  if (payload == null || payload.isEmpty) return;

  try {
    final data = jsonDecode(payload) as Map<String, dynamic>;
    final type = data['type'] as String?;

    debugPrint('[V2 App] 通知点击: type=$type, data=$data');

    final context = v2NavigatorKey.currentContext;
    if (context == null) {
      debugPrint('[V2 App] 无法获取导航上下文');
      return;
    }

    if (type == 'im_message') {
      final groupId = data['groupId'] as String? ?? '';
      if (groupId.isNotEmpty) {
        context.push('/group-chat/$groupId');
        debugPrint('[V2 App] 通知点击-跳转群聊: groupId=$groupId');
      }
    } else if (type == 'push_notification') {
      final courseId = data['courseId'] as String? ?? '';
      final classId = data['classId'] as String? ?? '';
      final cpi = data['cpi'] as String? ?? '';
      final hasHomeworkLink = data['hasHomeworkLink'] as bool? ?? false;
      final homeworkId = data['homeworkId'] as String? ?? '';
      final homeworkUrl = data['homeworkUrl'] as String? ?? '';

      if (hasHomeworkLink && homeworkId.isNotEmpty) {
        final url =
            '/course/$courseId/homework/$homeworkId'
            '?classId=$classId'
            '&cpi=$cpi'
            '${homeworkUrl.isNotEmpty ? '&taskUrl=${Uri.encodeComponent(homeworkUrl)}' : ''}';
        context.push(url);
        debugPrint('[V2 App] 通知点击-跳转作业: homeworkId=$homeworkId');
      } else if (courseId.isNotEmpty) {
        final courseName = data['title'] as String? ?? '';
        final url =
            '/course/$courseId'
            '?classId=$classId'
            '&cpi=$cpi'
            '&name=${Uri.encodeComponent(courseName)}';
        context.push(url);
        debugPrint('[V2 App] 通知点击-跳转课程: courseId=$courseId');
      }
    }
  } catch (e) {
    debugPrint('[V2 App] 通知点击处理失败: $e');
  }
}

class V2App extends ConsumerWidget {
  const V2App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final currentTheme = ref.watch(themeProvider);
    final compiledTheme = ThemeCompiler.compile(currentTheme);

    return MaterialApp.router(
      title: '超星',
      debugShowCheckedModeBanner: false,
      theme: compiledTheme,
      darkTheme: ThemeCompiler.compile(AppThemeData.darkTheme),
      themeMode: currentTheme.colors.isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
