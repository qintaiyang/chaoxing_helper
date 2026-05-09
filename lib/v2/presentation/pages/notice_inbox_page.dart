import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/staggered_animation.dart';
import '../../domain/entities/user_notice.dart';
import '../../infra/storage/storage_service.dart';
import '../../infra/theme/theme_extensions.dart';
import '../controllers/notice_controller.dart';
import '../providers/providers.dart';
import '../providers/services_providers.dart';
import '../widgets/error_view.dart';
import 'notice_detail_page.dart';
import 'homework_webview_page.dart';
import 'exam_webview_page.dart';

const _kNoticeInboxPageKey = 'notice_inbox_page';

class UserNoticeInboxPage extends ConsumerStatefulWidget {
  const UserNoticeInboxPage({super.key});

  @override
  ConsumerState<UserNoticeInboxPage> createState() =>
      _UserNoticeInboxPageState();
}

class _UserNoticeInboxPageState extends ConsumerState<UserNoticeInboxPage> {
  List<UserNotice> _notices = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  int _unreadCount = 0;
  String _puid = '';
  Set<int> _readIds = {};

  @override
  void initState() {
    super.initState();
    _loadPuidAndNotices();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_puid.isNotEmpty) {
      _refreshReadIds();
      _recalculateUnreadCount();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshReadIds() {
    _readIds = _NoticeReadStateManager.getReadIds(_puid);
  }

  void _recalculateUnreadCount() {
    final unread = _notices.where((n) {
      final id = int.tryParse(n.id) ?? 0;
      return !_readIds.contains(id);
    }).length;
    if (mounted) {
      setState(() => _unreadCount = unread);
    }
  }

  Future<void> _loadPuidAndNotices() async {
    final puid = ref.read(userNoticeListControllerProvider.notifier).getPuid();

    if (puid == null || puid.isEmpty) {
      debugPrint('未登录，无法加载通知');
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _puid = puid);
    _refreshReadIds();
    await _loadAllNotices();
  }

  void _onSessionVersionChanged() {
    setState(() {
      _notices = [];
      _isLoading = false;
      _isRefreshing = false;
      _unreadCount = 0;
    });
    ref.invalidate(userNoticeListControllerProvider);
    _loadPuidAndNotices();
  }

  void _onPushDispatched() {
    if (_puid.isEmpty || _isRefreshing || _isLoading) return;
    _loadAllNotices();
  }

  Future<void> _loadAllNotices() async {
    if (_puid.isEmpty) {
      final puid = ref
          .read(userNoticeListControllerProvider.notifier)
          .getPuid();
      if (puid == null || puid.isEmpty) {
        debugPrint('未登录，无法加载通知');
        setState(() => _isLoading = false);
        return;
      }
      setState(() => _puid = puid);
    }

    if (!_isRefreshing) {
      setState(() => _isLoading = true);
    }

    try {
      await ref.read(userNoticeListControllerProvider.notifier).refresh();
      final noticesAsync = await ref.read(
        userNoticeListControllerProvider.future,
      );

      if (mounted) {
        _refreshReadIds();
        setState(() {
          _notices = noticesAsync;
          _unreadCount = _notices.where((n) {
            final id = int.tryParse(n.id) ?? 0;
            return !_readIds.contains(id);
          }).length;
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      debugPrint('加载通知失败: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _refreshNotices() async {
    setState(() => _isRefreshing = true);
    await _loadAllNotices();
  }

  Future<void> _markAllAsRead() async {
    if (_notices.isEmpty) return;

    for (final notice in _notices) {
      final id = int.tryParse(notice.id) ?? 0;
      if (id > 0) {
        await _NoticeReadStateManager.markAsRead(_puid, id);
      }
    }

    _refreshReadIds();
    _recalculateUnreadCount();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已全部标记为已读'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final noticesAsync = ref.watch(userNoticeListControllerProvider);

    ref.listen<int>(sessionVersionProvider, (previous, next) {
      if (previous != next) {
        _onSessionVersionChanged();
      }
    });

    ref.listen<int>(pushDispatcherProvider.select((p) => p.pushCount.value), (
      previous,
      next,
    ) {
      if (previous != next && mounted && !_isRefreshing) {
        _onPushDispatched();
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('通知收件箱'),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _unreadCount > 99 ? '99+' : '$_unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                '一键已读',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshNotices,
            tooltip: '刷新',
          ),
        ],
      ),
      body: Container(
        decoration: _buildBackgroundDecoration(context),
        child: _isLoading
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight + MediaQuery.of(context).padding.top,
                  ),
                  child: const CircularProgressIndicator(),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + MediaQuery.of(context).padding.top,
                ),
                child: noticesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: ErrorView(
                      failure: e as dynamic,
                      onRetry: _refreshNotices,
                    ),
                  ),
                  data: (notices) {
                    if (notices.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: _refreshNotices,
                        child: ListView(
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height -
                                  kToolbarHeight -
                                  100,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.mail_outline,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '暂无通知',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refreshNotices,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _notices.isNotEmpty
                            ? _notices.length
                            : notices.length,
                        itemBuilder: (context, index) {
                          final noticeList = _notices.isNotEmpty
                              ? _notices
                              : notices;
                          return StaggeredItemAnimation(
                            index: index,
                            child: _buildNoticeTile(context, noticeList[index]),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Decoration? _buildBackgroundDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final bgExt = theme.extension<ThemeBackgrounds>();
    final decoration = bgExt?.getBackgroundDecoration(_kNoticeInboxPageKey);
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

  Widget _buildNoticeTile(BuildContext context, UserNotice notice) {
    final theme = Theme.of(context);
    final noticeId = int.tryParse(notice.id) ?? 0;
    final isRead = _readIds.contains(noticeId);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserNoticeDetailPage(notice: notice),
              ),
            );
            if (noticeId > 0) {
              await _NoticeReadStateManager.markAsRead(_puid, noticeId);
              _refreshReadIds();
              _recalculateUnreadCount();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: isRead ? 0.8 : 0.95,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isRead
                            ? theme.colorScheme.surfaceContainerHighest
                            : theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getSourceIcon(notice.sourceType),
                        color: isRead
                            ? theme.colorScheme.outline
                            : theme.colorScheme.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notice.title.isNotEmpty ? notice.title : '通知',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: isRead
                                        ? FontWeight.normal
                                        : FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notice.content,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  notice.getSourceTypeDescription(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${notice.createrName.isNotEmpty ? notice.createrName : '系统'} · ${notice.getTimeDescription()}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.outline,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.outline,
                      size: 18,
                    ),
                  ],
                ),
                if (notice.attachments.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  ...notice.attachments
                      .take(3)
                      .map((a) => _buildAttachmentButton(context, notice, a)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentButton(
    BuildContext context,
    UserNotice notice,
    UserNoticeAttachment attachment,
  ) {
    if (attachment.title.isEmpty) return const SizedBox.shrink();

    IconData icon;
    String label;
    if (attachment.isHomework) {
      icon = Icons.assignment;
      label = attachment.title.isNotEmpty ? attachment.title : '去作答';
    } else if (attachment.isExam) {
      icon = Icons.menu_book;
      label = attachment.title.isNotEmpty ? attachment.title : '开始考试';
    } else {
      icon = Icons.attach_file;
      label = attachment.title;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        onPressed: () => _openAttachment(context, notice, attachment),
        icon: Icon(icon, size: 18),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _openAttachment(
    BuildContext context,
    UserNotice notice,
    UserNoticeAttachment attachment,
  ) {
    if (attachment.isHomework) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => HomeworkWebViewPage(
            workId: attachment.examOrWorkId,
            courseId: attachment.courseId,
            classId: attachment.clazzId,
            cpi: '',
            enc: '',
            answerId: '',
            taskUrl: attachment.url,
          ),
        ),
      );
    } else if (attachment.isExam) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => ExamWebViewPage(
            courseId: attachment.courseId,
            classId: attachment.clazzId,
            cpi: '',
            examId: attachment.examOrWorkId,
            examTitle: attachment.title,
          ),
        ),
      );
    } else if (attachment.attachment.isNotEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('查看附件'),
          content: Text('附件: ${attachment.title}\n大小: ${attachment.size}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    }
  }

  IconData _getSourceIcon(int sourceType) {
    switch (sourceType) {
      case 14:
        return Icons.assignment;
      case 19:
        return Icons.quiz;
      case 4:
      case 54:
        return Icons.how_to_reg;
      case 1:
      case 45:
        return Icons.notifications;
      case 2:
        return Icons.folder;
      case 11:
        return Icons.person_add;
      case 43:
        return Icons.how_to_vote;
      case 5:
        return Icons.forum;
      case 42:
        return Icons.edit_note;
      case 23:
        return Icons.star;
      case 17:
        return Icons.videocam;
      case 61:
        return Icons.fingerprint;
      case 68:
        return Icons.gamepad;
      default:
        return Icons.mail;
    }
  }
}

class _NoticeReadStateManager {
  static const String _cacheKeyPrefix = 'notice_read_ids_';

  static String _getCacheKey(String puid) => '$_cacheKeyPrefix$puid';

  static Set<int> _loadReadIds(String puid) {
    final cacheKey = _getCacheKey(puid);
    try {
      final cached = SharedPreferencesStorage.instance.getStringSync(cacheKey);
      if (cached != null && cached.isNotEmpty) {
        final ids = <dynamic>[];
        try {
          final decodedList = <dynamic>[];
          for (final item
              in cached.replaceAll('[', '').replaceAll(']', '').split(',')) {
            final trimmed = item.trim();
            if (trimmed.isNotEmpty) {
              decodedList.add(int.tryParse(trimmed) ?? 0);
            }
          }
          ids.addAll(decodedList);
        } catch (_) {}
        return ids.whereType<int>().toSet();
      }
    } catch (e) {
      debugPrint('加载已读通知ID失败: $e');
    }
    return {};
  }

  static Future<void> _saveReadIds(String puid, Set<int> readIds) async {
    final cacheKey = _getCacheKey(puid);
    try {
      final idsList = readIds.toList();
      final jsonString = '[${idsList.join(',')}]';
      await SharedPreferencesStorage.instance.setString(cacheKey, jsonString);
    } catch (e) {
      debugPrint('保存已读通知ID失败: $e');
    }
  }

  static Future<void> markAsRead(String puid, int noticeId) async {
    final readIds = _loadReadIds(puid);
    if (readIds.contains(noticeId)) return;
    readIds.add(noticeId);
    await _saveReadIds(puid, readIds);
  }

  static Set<int> getReadIds(String puid) {
    return _loadReadIds(puid);
  }
}
