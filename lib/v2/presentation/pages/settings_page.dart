import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/auth_controller.dart';
import '../providers/providers.dart';
import '../../domain/entities/user.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final currentUser = authState.valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          _buildAccountSection(context, ref, currentUser),
          const Divider(height: 1),
          _buildGeneralSection(context),
          const Divider(height: 1),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, WidgetRef ref, User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '账户',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        if (user != null) ...[
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                user.name.isNotEmpty ? user.name[0] : 'U',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            title: Text(user.name),
            subtitle: Text(user.phone.isEmpty ? '未绑定手机' : user.phone),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAccountManager(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('修改密码'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/change-password'),
          ),
        ] else ...[
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('未登录'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/login'),
          ),
        ],
      ],
    );
  }

  Widget _buildGeneralSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '通用',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.palette),
          title: const Text('主题设置'),
          subtitle: const Text('自定义主题和页面背景'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/theme-settings'),
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: const Text('清理缓存'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _clearCache(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '关于',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('关于超星'),
          subtitle: Text('V2.0.0 - Clean Architecture'),
        ),
        const ListTile(
          leading: Icon(Icons.description_outlined),
          title: Text('开源协议'),
          subtitle: Text('MIT License'),
        ),
      ],
    );
  }

  void _showAccountManager(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _AccountManagerSheet(),
    );
  }

  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清理缓存'),
        content: const Text('确定要清理图片缓存吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('缓存已清理')));
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

class _AccountManagerSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref
        .watch(accountRepositoryProvider)
        .getAllAccounts()
        .fold((_) => <User>[], (a) => a);
    final currentSession = ref
        .watch(accountRepositoryProvider)
        .getCurrentSessionId()
        .fold((_) => null, (id) => id);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('账户管理', style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          if (accounts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('暂无账户')),
            )
          else
            ...accounts.map(
              (a) =>
                  _buildAccountItem(context, ref, a, a.uid == currentSession),
            ),
          const Divider(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
              icon: const Icon(Icons.add),
              label: const Text('添加账户'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(
    BuildContext context,
    WidgetRef ref,
    User account,
    bool isCurrent,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCurrent
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade300,
        child: Text(
          account.name.isNotEmpty ? account.name[0] : 'U',
          style: TextStyle(
            color: isCurrent ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(account.name),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '当前',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
      subtitle: Text(account.phone),
      trailing: isCurrent
          ? null
          : TextButton(
              onPressed: () => _switchAccount(context, ref, account),
              child: const Text('切换'),
            ),
      onTap: isCurrent
          ? () => _showAccountOptions(context, ref, account)
          : null,
    );
  }

  void _switchAccount(BuildContext context, WidgetRef ref, User account) {
    ref.read(accountRepositoryProvider).setCurrentSession(account.uid);
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已切换到 ${account.name}')));
  }

  void _showAccountOptions(BuildContext context, WidgetRef ref, User account) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('账户选项'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('退出登录'),
              onTap: () {
                Navigator.pop(ctx);
                _logoutAccount(context, ref, account);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  void _logoutAccount(BuildContext context, WidgetRef ref, User account) {
    ref.read(accountRepositoryProvider).removeAccounts([account.uid]);
    final accounts = ref
        .read(accountRepositoryProvider)
        .getAllAccounts()
        .fold((_) => <User>[], (a) => a);
    if (accounts.isEmpty) ref.read(authControllerProvider.notifier).logout();
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已退出登录')));
  }
}
