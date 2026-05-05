import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../../app_dependencies.dart';
import '../../domain/entities/active.dart';
import '../../domain/entities/enums.dart';
import '../../infra/theme/theme_extensions.dart';

class CourseDetailPage extends ConsumerStatefulWidget {
  final String courseId;
  final String classId;
  final String cpi;
  final String courseName;

  const CourseDetailPage({
    super.key,
    required this.courseId,
    required this.classId,
    required this.cpi,
    this.courseName = '',
  });

  @override
  ConsumerState<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends ConsumerState<CourseDetailPage> {
  List<Active> _activities = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final deps = AppDependencies.instance;
      final result = await deps.getActivitiesUseCase.execute(
        widget.courseId,
        widget.classId,
        widget.cpi,
      );
      if (mounted) {
        result.fold(
          (f) => setState(() {
            _loading = false;
            _error = f.message;
          }),
          (list) => setState(() {
            _activities = list;
            _loading = false;
          }),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  IconData _iconForActive(int type) {
    switch (type) {
      case 2:
        return Icons.qr_code_scanner;
      case 4:
        return Icons.location_on;
      case 1:
        return Icons.touch_app;
      default:
        return Icons.event;
    }
  }

  String _typeLabel(int type) {
    switch (type) {
      case 2:
        return '签到';
      case 4:
        return '位置签到';
      case 1:
        return '手势签到';
      default:
        return '活动';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName.isNotEmpty ? widget.courseName : '课程详情'),
      ),
      body: Container(
        decoration: _buildBackgroundDecoration(context),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(_error!),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: _loadActivities,
                      child: const Text('重试'),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadActivities,
                child: ListView(
                  children: [
                    _buildFeatureGrid(theme),
                    const Divider(height: 1),
                    if (_activities.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            '暂无活动',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ..._activities.map((a) => _buildActivityCard(a, theme)),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
    );
  }

  Decoration? _buildBackgroundDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final bgExt = theme.extension<ThemeBackgrounds>();
    const pageKey = 'course_detail';
    final decoration = bgExt?.getBackgroundDecoration(pageKey);
    if (decoration != null) return decoration;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [theme.colorScheme.surfaceContainer, theme.colorScheme.surface],
      ),
    );
  }

  Widget _buildFeatureGrid(ThemeData theme) {
    final items = [
      (
        '作业',
        Icons.assignment,
        Colors.blue,
        () => context.push(
          '/course/${widget.courseId}/homework?classId=${widget.classId}&cpi=${widget.cpi}',
        ),
      ),
      (
        '考试',
        Icons.quiz,
        Colors.purple,
        () => context.push(
          '/course/${widget.courseId}/exams?classId=${widget.classId}&cpi=${widget.cpi}',
        ),
      ),
      (
        '资料',
        Icons.folder_open,
        Colors.orange,
        () async {
          final sessionResult = AppDependencies.instance.accountRepo
              .getCurrentSessionId();
          final puid = sessionResult.fold((_) => '0', (id) => id ?? '0');
          context.push(
            '/course/${widget.courseId}/materials?classId=${widget.classId}&cpi=${widget.cpi}&puid=$puid',
          );
        },
      ),
      ('群聊', Icons.group, Colors.teal, () => _openCourseGroupChat(context)),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.85,
      children: items
          .map(
            (item) => InkWell(
              onTap: item.$4,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.$3.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.$2, color: item.$3, size: 26),
                  ),
                  const SizedBox(height: 6),
                  Text(item.$1, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildActivityCard(Active active, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: active.status
                ? theme.colorScheme.primaryContainer
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _iconForActive(active.type),
            color: active.status ? theme.colorScheme.primary : Colors.grey,
            size: 28,
          ),
        ),
        title: Text(
          active.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (active.description.isNotEmpty)
              Text(
                active.description,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: active.status
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _typeLabel(active.type),
                    style: TextStyle(
                      fontSize: 11,
                      color: active.status ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '参与: ${active.attendNum}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: active.status
            ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
            : Icon(Icons.lock, size: 16, color: Colors.grey.shade300),
        onTap: active.status ? () => _navigateToActivity(active) : null,
      ),
    );
  }

  void _navigateToActivity(Active active) {
    switch (active.activeType) {
      case ActiveType.signIn:
      case ActiveType.scheduledSignIn:
      case ActiveType.signOut:
        context.push(
          '/signin/${active.id}?courseId=${widget.courseId}&classId=${widget.classId}&cpi=${widget.cpi}',
        );
        break;
      case ActiveType.quiz:
      case ActiveType.vote:
      case ActiveType.questionnaire:
      case ActiveType.topicDiscuss:
      case ActiveType.evaluation:
      case ActiveType.interactivePractice:
        if (active.url.isNotEmpty) {
          final encodedUrl = Uri.encodeComponent(active.url);
          context.push(
            '/activity/${active.id}?url=$encodedUrl&name=${Uri.encodeComponent(active.name)}&courseId=${widget.courseId}&classId=${widget.classId}',
          );
        } else {
          _snack('活动链接不可用');
        }
        break;
      case ActiveType.work:
        context.push(
          '/course/${widget.courseId}/homework?classId=${widget.classId}&cpi=${widget.cpi}',
        );
        break;
      case ActiveType.notice:
        context.push('/course/${widget.courseId}/notices');
        break;
      default:
        if (active.url.isNotEmpty) {
          final encodedUrl = Uri.encodeComponent(active.url);
          context.push(
            '/activity/${active.id}?url=$encodedUrl&name=${Uri.encodeComponent(active.name)}&courseId=${widget.courseId}&classId=${widget.classId}',
          );
        } else {
          _snack('该活动类型暂不支持: ${active.activeType.label}');
        }
        break;
    }
  }

  void _snack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _openCourseGroupChat(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final im = AppDependencies.instance.imService;
      if (!im.isLoggedIn) {
        final sessionResult = AppDependencies.instance.accountRepo
            .getCurrentSessionId();
        final sessionId = sessionResult.fold((_) => null, (id) => id);
        if (sessionId != null) {
          final userResult = AppDependencies.instance.accountRepo
              .getAccountById(sessionId);
          userResult.fold((_) => null, (user) {
            if (user != null && user.imAccount != null) {
              im.login(user.imAccount!.userName, user.imAccount!.password);
            }
          });
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      if (!im.isLoggedIn) {
        if (context.mounted) {
          messenger.showSnackBar(const SnackBar(content: Text('IM未登录，无法打开群聊')));
        }
        return;
      }

      final groups = await EMClient.getInstance.groupManager.getJoinedGroups();

      String? matchedGroupId;
      String? matchedGroupName;

      for (final group in groups) {
        final extJson = group.extension?.isNotEmpty == true
            ? group.extension
            : (group.desc?.isNotEmpty == true ? group.desc : null);

        if (extJson != null && extJson.isNotEmpty) {
          try {
            final ext = jsonDecode(extJson) as Map<String, dynamic>;
            final courseInfo = ext['courseInfo'];
            if (courseInfo != null) {
              final groupId = courseInfo['courseid']?.toString();
              if (groupId == widget.courseId) {
                matchedGroupId = group.groupId;
                matchedGroupName =
                    courseInfo['coursename']?.toString() ??
                    group.groupName ??
                    '课程群聊';
                break;
              }
            }
          } catch (_) {}
        }
      }

      if (matchedGroupId != null && context.mounted) {
        context.push(
          '/group-chat/$matchedGroupId?title=${Uri.encodeComponent(matchedGroupName!)}&isGroup=true',
        );
      } else if (context.mounted) {
        messenger.showSnackBar(const SnackBar(content: Text('该课程暂无群聊')));
      }
    } catch (e) {
      if (context.mounted) {
        messenger.showSnackBar(SnackBar(content: Text('打开群聊失败: $e')));
      }
    }
  }
}
