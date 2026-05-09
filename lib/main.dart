import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'v2/app.dart';
import 'v2/app_dependencies.dart';
import 'v2/infra/services/notification_service.dart';
import 'v2/presentation/widgets/battery_optimization_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDependencies.instance.initialize();

  try {
    AppDependencies.instance.imService.initialize();
  } catch (e) {
    debugPrint('环信 IM 初始化跳过: $e');
  }

  if (Platform.isAndroid) {
    try {
      FlutterForegroundTask.addTaskDataCallback((data) {
        if (data == 'keepalive') {
          AppDependencies.instance.imService.onForegroundServiceKeepAlive();
        }
      });
    } catch (e) {
      debugPrint('前台服务保活监听注册失败: $e');
    }
  }

  try {
    await NotificationService().initialize(
      onNotificationTap: handleNotificationTap,
    );
    await NotificationService().requestPermission();
  } catch (e) {
    debugPrint('通知服务初始化跳过: $e');
  }

  runApp(
    ProviderScope(
      child: _AppWithBatteryCheck(
        child: const V2App(),
      ),
    ),
  );
}

class _AppWithBatteryCheck extends StatefulWidget {
  final Widget child;

  const _AppWithBatteryCheck({required this.child});

  @override
  State<_AppWithBatteryCheck> createState() => _AppWithBatteryCheckState();
}

class _AppWithBatteryCheckState extends State<_AppWithBatteryCheck> {
  bool _hasShownBatteryDialog = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid && !_hasShownBatteryDialog) {
      _checkBatteryOptimization();
    }
  }

  Future<void> _checkBatteryOptimization() async {
    try {
      final isIgnoring =
          await FlutterForegroundTask.isIgnoringBatteryOptimizations;
      if (!isIgnoring && mounted && !_hasShownBatteryDialog) {
        _hasShownBatteryDialog = true;
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          BatteryOptimizationDialog.show(context);
        }
      }
    } catch (e) {
      debugPrint('检查电池优化状态失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
