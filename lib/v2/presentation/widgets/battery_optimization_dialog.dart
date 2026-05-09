import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class BatteryOptimizationDialog extends StatelessWidget {
  const BatteryOptimizationDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const BatteryOptimizationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      icon: Icon(
        Icons.battery_alert,
        size: 48,
        color: theme.colorScheme.primary,
      ),
      title: const Text('开启后台通知'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '为了确保您能及时收到课程通知，需要进行以下设置：',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildStepItem(
              context,
              index: 1,
              title: '关闭电池优化',
              subtitle: '允许应用在后台运行，不被系统清理',
              icon: Icons.battery_std,
              onTap: () => _requestIgnoreBatteryOptimization(context),
            ),
            const SizedBox(height: 8),
            _buildStepItem(
              context,
              index: 2,
              title: '开启应用自启动',
              subtitle: '允许应用开机自启，保持后台服务运行',
              icon: Icons.play_circle_outline,
              onTap: () => _openAutoStartSetting(context),
            ),
            const SizedBox(height: 8),
            _buildStepItem(
              context,
              index: 3,
              title: '锁定应用后台运行',
              subtitle: '在最近任务列表中锁定本应用',
              icon: Icons.lock_outline,
              onTap: () => _showLockAppGuide(context),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('稍后设置', style: TextStyle(color: theme.colorScheme.outline)),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('我知道了'),
        ),
      ],
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$index',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }

  Future<void> _requestIgnoreBatteryOptimization(BuildContext context) async {
    try {
      final alreadyIgnoring =
          await FlutterForegroundTask.isIgnoringBatteryOptimizations;
      if (alreadyIgnoring) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已关闭电池优化，无需重复设置')),
          );
        }
        return;
      }

      final granted = await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      if (context.mounted) {
        if (granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已关闭电池优化')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('设置已取消，请手动在系统设置中关闭电池优化')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  Future<void> _openAutoStartSetting(BuildContext context) async {
    try {
      final brand = _getDeviceBrand();
      if (context.mounted) {
        _showManualAutoStartGuide(context, brand: brand);
      }
    } catch (e) {
      if (context.mounted) {
        _showManualAutoStartGuide(context);
      }
    }
  }

  void _showManualAutoStartGuide(BuildContext context, {String? brand}) {
    final deviceBrand = brand ?? _getDeviceBrand();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('手动开启自启动 - $deviceBrand'),
        content: Text(_getAutoStartGuide(deviceBrand)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showLockAppGuide(BuildContext context) {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('锁定应用后台运行'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '请在最近任务列表中找到本应用，然后：',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            _buildGuideStep('1. 从屏幕底部上滑并停顿，进入最近任务列表'),
            _buildGuideStep('2. 长按本应用卡片'),
            _buildGuideStep('3. 点击锁定图标（通常是锁形图标）'),
            const SizedBox(height: 12),
            Text(
              '锁定后，应用不会被系统清理，可以持续接收通知。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  String _getDeviceBrand() {
    if (!Platform.isAndroid) return '未知设备';

    final brand = Platform.environment['BRAND']?.toLowerCase() ?? '';
    final manufacturer = Platform.environment['MANUFACTURER']?.toLowerCase() ?? '';

    if (brand.contains('huawei') || manufacturer.contains('huawei')) {
      return '华为/荣耀';
    } else if (brand.contains('xiaomi') || brand.contains('redmi')) {
      return '小米/红米';
    } else if (brand.contains('oppo')) {
      return 'OPPO';
    } else if (brand.contains('vivo')) {
      return 'vivo';
    } else if (brand.contains('oneplus')) {
      return '一加';
    } else if (brand.contains('samsung')) {
      return '三星';
    } else if (brand.contains('meizu')) {
      return '魅族';
    }

    return '其他品牌';
  }

  String _getAutoStartGuide(String brand) {
    switch (brand) {
      case '华为/荣耀':
        return '打开手机管家 > 应用启动管理 > 找到"超星" > 开启"允许自启动、允许关联启动、允许后台活动"';
      case '小米/红米':
        return '打开设置 > 应用设置 > 授权管理 > 自启动管理 > 找到"超星" > 开启自启动';
      case 'OPPO':
        return '打开手机管家 > 权限隐私 > 自启动管理 > 找到"超星" > 开启自启动';
      case 'vivo':
        return '打开i管家 > 应用管理 > 自启动管理 > 找到"超星" > 开启自启动';
      case '一加':
        return '打开设置 > 应用 > 自启动管理 > 找到"超星" > 开启自启动';
      case '三星':
        return '打开设置 > 电池和设备维护 > 电池 > 后台使用限制 > 将"超星"添加到"不限制的应用程序"';
      case '魅族':
        return '打开设置 > 应用管理 > 权限管理 > 自启动管理 > 找到"超星" > 开启自启动';
      default:
        return '请在手机设置中搜索"自启动"或"应用启动"，找到"超星"后开启。不同品牌手机路径可能有所不同。';
    }
  }
}
