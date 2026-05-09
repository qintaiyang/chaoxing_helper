import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app_dependencies.dart';
import '../../domain/entities/homework.dart';
import '../../domain/entities/course.dart';

class HomeworkPage extends ConsumerStatefulWidget {
  const HomeworkPage({super.key});

  @override
  ConsumerState<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends ConsumerState<HomeworkPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _allHomework = [];
  final Map<String, Course?> _courseCache = {};

  @override
  void initState() {
    super.initState();
    _loadAllHomework();
  }

  Future<void> _loadAllHomework() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final courses = await _getCourses();
      final allHomework = <Map<String, dynamic>>[];

      for (final course in courses) {
        try {
          final courseId = course.courseId;
          final classId = course.classId;
          final cpi = course.cpi ?? '';

          final result = await AppDependencies.instance.getHomeworkListUseCase
              .execute(courseId, classId, cpi);

          result.fold(
            (failure) {
              debugPrint('获取课程 ${course.name} 作业失败: ${failure.message}');
            },
            (homeworkList) {
              for (final hw in homeworkList) {
                allHomework.add({'homework': hw, 'course': course});
              }
            },
          );
        } catch (e) {
          debugPrint('获取课程 ${course.name} 作业异常: $e');
        }
      }

      allHomework.sort((a, b) {
        final hwA = a['homework'] as HomeworkInfo;
        final hwB = b['homework'] as HomeworkInfo;
        return _statusPriority(
          hwA.status,
        ).compareTo(_statusPriority(hwB.status));
      });

      if (mounted) {
        setState(() {
          _allHomework = allHomework;
          _loading = false;
        });
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

  int _statusPriority(String status) {
    final s = status.trim();
    if (s.contains('未交') || s.contains('未开始') || s.contains('待提交')) {
      return 0;
    }
    if (s.contains('已完成') ||
        s.contains('已提交') ||
        s.contains('已批') ||
        s.contains('已查')) {
      return 1;
    }
    if (s.contains('过期') || s.contains('截止')) {
      return 2;
    }
    return 3;
  }

  Future<List<Course>> _getCourses() async {
    try {
      final courseResult = await AppDependencies.instance.getCoursesUseCase
          .execute();
      return courseResult.fold(
        (failure) {
          debugPrint('获取课程列表失败: ${failure.message}');
          return <Course>[];
        },
        (courses) {
          _courseCache.addAll({for (final c in courses) c.courseId: c});
          return courses;
        },
      );
    } catch (e) {
      debugPrint('获取课程列表异常: $e');
      return [];
    }
  }

  String _statusLabel(String s) {
    final t = s.trim();
    if (t.contains('已完成') ||
        t.contains('已提交') ||
        t.contains('已批') ||
        t.contains('已查'))
      return '已完成';
    if (t.contains('未交') || t.contains('未开始') || t.contains('待提交'))
      return '未完成';
    if (t.contains('过期') || t.contains('截止')) return '已过期';
    return t.isNotEmpty ? t : '未完成';
  }

  Color _statusColor(String s) {
    switch (_statusLabel(s)) {
      case '已完成':
        return Colors.green;
      case '已过期':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String s) {
    switch (_statusLabel(s)) {
      case '已完成':
        return Icons.check_circle;
      case '已过期':
        return Icons.error_outline;
      default:
        return Icons.assignment_outlined;
    }
  }

  void _showDetail(HomeworkInfo hw, Course? course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(hw.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '课程: ${course?.name ?? '未知'}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '状态: ${_statusLabel(hw.status)}',
                style: TextStyle(
                  color: _statusColor(hw.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '作业ID: ${hw.workId}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'AnswerID: ${hw.answerId}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Enc: ${hw.enc}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              if (hw.taskUrl.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '链接: ${hw.taskUrl}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _openHomework(hw);
            },
            child: const Text('开始作答'),
          ),
        ],
      ),
    );
  }

  void _openHomework(HomeworkInfo hw) {
    context.push(
      '/course/${hw.courseId}/homework/${hw.workId}'
      '?classId=${hw.classId}'
      '&cpi=${hw.cpi}'
      '&enc=${Uri.encodeComponent(hw.enc)}'
      '&answerId=${Uri.encodeComponent(hw.answerId)}'
      '&taskUrl=${Uri.encodeComponent(hw.taskUrl)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('作业'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Container(
        decoration: _buildBackgroundDecoration(context),
        child: Padding(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
          ),
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
                        onPressed: _loadAllHomework,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : _allHomework.isEmpty
              ? RefreshIndicator(
                  onRefresh: _loadAllHomework,
                  child: ListView(
                    children: const [
                      SizedBox(height: 200, child: Center(child: Text('暂无作业'))),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAllHomework,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _allHomework.length,
                    itemBuilder: (_, i) {
                      final item = _allHomework[i];
                      final hw = item['homework'] as HomeworkInfo;
                      final course = item['course'] as Course?;
                      return _buildHomeworkCard(hw, course, theme);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHomeworkCard(HomeworkInfo hw, Course? course, ThemeData theme) {
    final statusLabel = _statusLabel(hw.status);
    final statusColor = _statusColor(hw.status);
    final statusIcon = _statusIcon(hw.status);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(statusIcon, color: statusColor, size: 26),
        ),
        title: Text(
          hw.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (course != null)
              Text(
                course.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.outline,
                ),
              ),
            const SizedBox(height: 2),
            Text(
              statusLabel,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showDetail(hw, course),
      ),
    );
  }

  Decoration? _buildBackgroundDecoration(BuildContext context) {
    final theme = Theme.of(context);
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
