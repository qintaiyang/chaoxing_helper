import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app_dependencies.dart';
import '../../domain/entities/user.dart';
import '../../infra/theme/theme_extensions.dart';
import '../controllers/course_controller.dart';
import '../providers/providers.dart';
import '../providers/activity_popup_preferences_provider.dart';
import '../widgets/network_image.dart';
import '../widgets/battery_optimization_dialog.dart';

class AccountsPage extends ConsumerStatefulWidget {
  const AccountsPage({super.key});

  @override
  ConsumerState<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends ConsumerState<AccountsPage> {
  List<User> _accounts = [];
  String? _currentAccountId;
  final Set<String> _selectedAccounts = {};
  bool _isMultiSelectMode = false;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _preloadCookies();
  }

  void _loadAccounts() {
    final accountRepo = AppDependencies.instance.accountRepo;
    final session = accountRepo.getCurrentSessionId().fold(
      (_) => null,
      (id) => id,
    );
    final accounts = accountRepo.getAllAccounts().fold(
      (_) => <User>[],
      (list) => list,
    );

    setState(() {
      _currentAccountId = session;
      _accounts = accounts;
    });
  }

  Future<void> _preloadCookies() async {
    final cookieManager = AppDependencies.instance.cookieManager;
    final accountIds = _accounts.map((a) => a.uid).toList();
    await cookieManager.preloadCookiesForAllUsers(accountIds);
  }

  void _toggleSelection(String userId) {
    setState(() {
      if (_selectedAccounts.contains(userId)) {
        _selectedAccounts.remove(userId);
      } else {
        _selectedAccounts.add(userId);
      }
      if (_selectedAccounts.isEmpty) _isMultiSelectMode = false;
    });
  }

  Future<void> _switchAccount(User account) async {
    final deps = AppDependencies.instance;
    await deps.accountRepo.addAccount(account);
    await deps.accountRepo.setCurrentSession(account.uid);

    ref.invalidate(courseListControllerProvider);
    ref.invalidate(activityListControllerProvider);
    ref.read(sessionVersionProvider.notifier).increment();

    setState(() {
      _currentAccountId = account.uid;
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('已切换到 ${account.name}')));
    }
  }

  Future<void> _deleteAccounts() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除账户'),
        content: Text('确定删除 ${_selectedAccounts.length} 个账户吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await AppDependencies.instance.accountRepo.removeAccounts(
      _selectedAccounts.toList(),
    );
    setState(() {
      _selectedAccounts.clear();
      _isMultiSelectMode = false;
    });
    _loadAccounts();
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('设置'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Platform.isAndroid)
                ListTile(
                  leading: const Icon(Icons.battery_alert),
                  title: const Text('后台通知设置'),
                  subtitle: const Text('电池优化、自启动管理，确保后台正常接收消息'),
                  onTap: () {
                    Navigator.pop(ctx);
                    BatteryOptimizationDialog.show(context);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('通知说明'),
                subtitle: const Text('IM 消息通知、推送设置'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showNotificationInfo(context);
                },
              ),
              Consumer(
                builder: (context, ref, _) {
                  final popupPrefs = ref.watch(
                    activityPopupPreferencesProvider,
                  );
                  return SwitchListTile(
                    secondary: const Icon(Icons.chat_bubble_outline),
                    title: const Text('活动/签到弹窗'),
                    subtitle: const Text('收到签到、活动等通知时显示弹窗'),
                    value: popupPrefs.enabled,
                    onChanged: (value) {
                      ref
                          .read(activityPopupPreferencesProvider.notifier)
                          .setEnabled(value);
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('主题设置'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/theme-settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.apps),
                title: const Text('自定义图标和启动图'),
                subtitle: const Text('更换应用图标和启动画面'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/custom-icon-splash');
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('修改密码'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/change-password');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('清除所有缓存'),
                onTap: () {
                  Navigator.pop(ctx);
                  _clearAllCache();
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('退出所有账号'),
                onTap: () {
                  Navigator.pop(ctx);
                  _logoutAll();
                },
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showNotificationInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('通知说明'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• 应用使用环信 IM 实时推送群组消息',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '• 应用退到后台时，前台服务会保持连接不中断',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '• 建议关闭电池优化，避免系统杀死后台',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '• 建议开启自启动权限，保持常驻后台',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  void _clearAllCache() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('缓存已清除')));
  }

  Future<void> _logoutAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('退出所有账号'),
        content: const Text('确定要退出所有账号吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('退出'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已退出所有账号')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final currentAccount = _accounts
        .where((a) => a.uid == _currentAccountId)
        .firstOrNull;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('账号'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          if (_isMultiSelectMode) ...[
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              tooltip: '删除选中',
              onPressed: _selectedAccounts.isNotEmpty ? _deleteAccounts : null,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedAccounts.clear();
                  _isMultiSelectMode = false;
                });
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text('取消'),
            ),
          ] else
            PopupMenuButton<String>(
              iconColor: Colors.white,
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'multi',
                  child: ListTile(
                    leading: Icon(Icons.checklist),
                    title: Text('多选管理'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('设置'),
                  ),
                ),
              ],
              onSelected: (val) {
                if (val == 'multi') {
                  setState(() => _isMultiSelectMode = true);
                } else if (val == 'settings') {
                  _showSettings(context);
                }
              },
            ),
        ],
      ),
      body: Container(
        decoration: _buildBackgroundDecoration(context),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
          ),
          child: Column(
            children: [
              if (currentAccount != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: currentAccount.avatar.isNotEmpty
                            ? ChaoxingNetworkImage(
                                url: currentAccount.avatar,
                                width: 72,
                                height: 72,
                              ).image
                            : null,
                        child: currentAccount.avatar.isEmpty
                            ? Text(
                                currentAccount.name.isNotEmpty
                                    ? currentAccount.name[0]
                                    : '?',
                                style: const TextStyle(fontSize: 28),
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentAccount.name,
                        style: theme.textTheme.titleLarge,
                      ),
                      if (currentAccount.phone.isNotEmpty)
                        Text(
                          currentAccount.phone,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      if (currentAccount.school.isNotEmpty)
                        Text(
                          currentAccount.school,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                    ],
                  ),
                ),
              Divider(
                height: 1,
                thickness: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
              Expanded(
                child: _accounts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '暂无账户',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () => context.push('/login'),
                              icon: const Icon(Icons.login),
                              label: const Text('添加账户'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _accounts.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _accounts.length) {
                            return ListTile(
                              leading: const Icon(Icons.add_circle_outline),
                              title: const Text('添加账户'),
                              onTap: () => context.push('/login'),
                            );
                          }

                          final account = _accounts[index];
                          final isCurrent = account.uid == _currentAccountId;

                          if (_isMultiSelectMode) {
                            return CheckboxListTile(
                              value: _selectedAccounts.contains(account.uid),
                              onChanged: (_) => _toggleSelection(account.uid),
                              title: Text(account.name),
                              subtitle: Text(account.phone),
                            );
                          }

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: account.avatar.isNotEmpty
                                  ? ChaoxingNetworkImage(
                                      url: account.avatar,
                                      width: 40,
                                      height: 40,
                                    ).image
                                  : null,
                              child: account.avatar.isEmpty
                                  ? Text(
                                      account.name.isNotEmpty
                                          ? account.name[0].toUpperCase()
                                          : '?',
                                    )
                                  : null,
                            ),
                            title: Text(account.name),
                            subtitle: Text(account.phone),
                            trailing: isCurrent
                                ? Chip(
                                    label: const Text('当前账号'),
                                    backgroundColor:
                                        theme.colorScheme.primaryContainer,
                                  )
                                : null,
                            onTap: isCurrent
                                ? null
                                : () => _switchAccount(account),
                            onLongPress: () {
                              setState(() {
                                _isMultiSelectMode = true;
                                _selectedAccounts.add(account.uid);
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Decoration? _buildBackgroundDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final bgExt = theme.extension<ThemeBackgrounds>();
    final decoration = bgExt?.getBackgroundDecoration('accounts_page');
    if (decoration != null) return decoration;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.colorScheme.primary.withValues(alpha: 0.3),
          theme.colorScheme.surface,
        ],
      ),
    );
  }
}
