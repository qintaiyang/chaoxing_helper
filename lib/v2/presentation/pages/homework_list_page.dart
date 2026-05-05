import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app_dependencies.dart';
import '../../domain/entities/homework.dart';

class HomeworkListPage extends StatefulWidget {
  final String courseId;
  final String classId;
  final String cpi;
  const HomeworkListPage({
    super.key,
    required this.courseId,
    required this.classId,
    required this.cpi,
  });

  @override
  State<HomeworkListPage> createState() => _HomeworkListPageState();
}

class _HomeworkListPageState extends State<HomeworkListPage> {
  List<HomeworkInfo> _list = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await AppDependencies.instance.getHomeworkListUseCase
          .execute(widget.courseId, widget.classId, widget.cpi);
      if (mounted)
        result.fold(
          (f) => setState(() {
            _loading = false;
            _error = f.message;
          }),
          (list) => setState(() {
            _list = list;
            _loading = false;
          }),
        );
    } catch (e) {
      if (mounted)
        setState(() {
          _loading = false;
          _error = e.toString();
        });
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

  void _showDetail(HomeworkInfo hw) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(hw.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    return Scaffold(
      appBar: AppBar(title: const Text('作业列表')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(_error!),
                  const SizedBox(height: 16),
                  FilledButton.tonal(onPressed: _load, child: const Text('重试')),
                ],
              ),
            )
          : _list.isEmpty
          ? RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                children: const [
                  SizedBox(height: 200, child: Center(child: Text('暂无作业'))),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _list.length,
                itemBuilder: (_, i) {
                  final hw = _list[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      leading: Icon(
                        _statusLabel(hw.status) == '已完成'
                            ? Icons.check_circle
                            : Icons.assignment,
                        color: _statusColor(hw.status),
                      ),
                      title: Text(
                        hw.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _statusLabel(hw.status),
                        style: TextStyle(
                          color: _statusColor(hw.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showDetail(hw),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
