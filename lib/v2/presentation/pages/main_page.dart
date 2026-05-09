import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_dependencies.dart';
import 'course_list_page.dart';
import 'group_list_page.dart';
import 'pan_page.dart';
import 'accounts_page.dart';

final GlobalKey<GroupListPageState> v2GroupListKey =
    GlobalKey<GroupListPageState>();

class V2MainPage extends ConsumerStatefulWidget {
  const V2MainPage({super.key});

  @override
  ConsumerState<V2MainPage> createState() => _V2MainPageState();
}

class _V2MainPageState extends ConsumerState<V2MainPage>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pages = [
      const CourseListPage(),
      GroupListPage(key: v2GroupListKey),
      const PanPage(),
      const AccountsPage(),
    ];
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final isForeground = state == AppLifecycleState.resumed;
    AppDependencies.instance.imService.setAppForeground(isForeground);

    if (isForeground && _selectedIndex == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        v2GroupListKey.currentState?.onVisibilityChanged();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pageColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.inversePrimary,
    ];
    final currentSeedColor = pageColors[_selectedIndex];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.school), label: '课程'),
          NavigationDestination(icon: Icon(Icons.group), label: '群组'),
          NavigationDestination(icon: Icon(Icons.cloud), label: '云盘'),
          NavigationDestination(icon: Icon(Icons.account_circle), label: '账号'),
        ],
        selectedIndex: _selectedIndex,
        indicatorColor: currentSeedColor.withValues(alpha: 0.15),
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          if (index == 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              v2GroupListKey.currentState?.onVisibilityChanged();
            });
          }
        },
        backgroundColor: colorScheme.surface,
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
