import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/custom_icon_splash_provider.dart';

class CustomIconAndSplashPage extends ConsumerWidget {
  const CustomIconAndSplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customIconAndSplashProvider);
    final theme = Theme.of(context);
    final notifier = ref.read(customIconAndSplashProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('自定义图标和启动图')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildIconSection(context, state, notifier, theme),
          const SizedBox(height: 16),
          _buildSplashSection(context, state, notifier, theme),
        ],
      ),
    );
  }

  Widget _buildIconSection(
    BuildContext context,
    CustomIconAndSplashState state,
    CustomIconAndSplashNotifier notifier,
    ThemeData theme,
  ) {
    final hasIcon = state.customIconPath != null;
    final hasCustom = state.isCustomIcon;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.apps, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text('应用图标',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hasCustom ? '自定义图标已创建' : '选择图片创建自定义桌面图标',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (hasIcon)
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(File(state.customIconPath!),
                            width: 80, height: 80, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 8),
                      Text('预览', style: theme.textTheme.bodySmall),
                    ],
                  )
                else
                  Column(
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.apps, size: 40,
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Text('未选择', style: theme.textTheme.bodySmall),
                    ],
                  ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton.icon(
                        onPressed: () async {
                          final path = await notifier.changeIcon();
                          if (context.mounted && path != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('图片已选择')),
                            );
                          }
                        },
                        icon: const Icon(Icons.photo_library),
                        label: Text(hasIcon ? '重新选择' : '选择图片'),
                      ),
                      const SizedBox(height: 8),
                      if (hasIcon)
                        FilledButton.icon(
                          onPressed: () async {
                            final success = await notifier.applyAndSwitchIcon(1);
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(success ? '快捷方式已请求' : '操作失败'),
                                  content: Text(success
                                      ? '系统弹出确认框后点击"添加到主屏幕"。\n桌面将出现自定义图标的快捷方式。'
                                      : '请重试'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('知道了'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.push_pin),
                          label: const Text('应用自定义图标'),
                          style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.tertiary),
                        ),
                      const SizedBox(height: 8),
                      if (hasCustom)
                        OutlinedButton.icon(
                          onPressed: () async {
                            final success = await notifier.applyAndSwitchIcon(0);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text(success ? '已恢复默认图标' : '恢复失败')),
                              );
                            }
                          },
                          icon: const Icon(Icons.restore),
                          label: const Text('恢复默认图标'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            side: BorderSide(color: theme.colorScheme.error),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20,
                      color: theme.colorScheme.onPrimaryContainer),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasCustom
                          ? '自定义快捷方式已创建，桌面应有新旧两个图标'
                          : '①选择图片 → ②应用自定义图标 → ③确认系统弹窗',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplashSection(
    BuildContext context,
    CustomIconAndSplashState state,
    CustomIconAndSplashNotifier notifier,
    ThemeData theme,
  ) {
    final hasSplash = state.customSplashPath != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wallpaper, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text('启动图',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text('选择图片作为应用启动画面', style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            if (hasSplash)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(state.customSplashPath!),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 300,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                        child: Text('图片已失效',
                            style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant))),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wallpaper, size: 60,
                        color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 8),
                    Text('默认启动图',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      final path = await notifier.changeSplash();
                      if (context.mounted && path != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('启动图已设置，下次启动生效')),
                        );
                      }
                    },
                    icon: const Icon(Icons.photo_library),
                    label: Text(hasSplash ? '更换图片' : '选择图片'),
                  ),
                ),
                const SizedBox(width: 12),
                if (hasSplash)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        notifier.resetCustomSplash();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已恢复默认启动图')),
                        );
                      },
                      icon: const Icon(Icons.restore),
                      label: const Text('恢复默认'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(color: theme.colorScheme.error),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
