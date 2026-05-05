import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app_dependencies.dart';
import '../../domain/entities/exam.dart';

class ExamListPage extends StatefulWidget {
  final String courseId;
  final String classId;
  final String cpi;
  const ExamListPage({
    super.key,
    required this.courseId,
    required this.classId,
    required this.cpi,
  });

  @override
  State<ExamListPage> createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage> {
  List<Exam> _list = [];
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
      final result = await AppDependencies.instance.getExamListUseCase
          .execute(
            courseId: widget.courseId,
            classId: widget.classId,
          );
      if (mounted) {
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

  String _statusLabel(Exam exam) {
    if (exam.isCompleted) return '已完成';
    if (exam.isStarted && !exam.isCompleted) return '进行中';
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (exam.startTime > 0 && now < exam.startTime) return '未开始';
    if (exam.endTime > 0 && now > exam.endTime) return '已过期';
    return '进行中';
  }

  Color _statusColor(String label) {
    switch (label) {
      case '已完成':
        return Colors.green;
      case '进行中':
        return Colors.blue;
      case '已过期':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void _showDetail(Exam exam) {
    final statusLabel = _statusLabel(exam);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(exam.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '状态: $statusLabel',
              style: TextStyle(
                color: _statusColor(statusLabel),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text('考试ID: ${exam.examId}'),
            if (exam.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(exam.description),
            ],
            const SizedBox(height: 12),
            Text('总分: ${exam.totalScore} / 通过分: ${exam.passScore}'),
            if (exam.duration > 0)
              Text('时长: ${exam.duration} 分钟'),
            if (exam.score != null)
              Text('你的成绩: ${exam.score}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
          if (!exam.isCompleted && statusLabel == '进行中')
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _openExam(exam);
              },
              child: const Text('开始考试'),
            ),
        ],
      ),
    );
  }

  void _openExam(Exam exam) {
    context.push(
      '/course/${exam.courseId}/exam/${exam.examId}'
      '?classId=${exam.classId}'
      '&cpi=${widget.cpi}'
      '&title=${Uri.encodeComponent(exam.title)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('考试列表')),
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
                  SizedBox(height: 200, child: Center(child: Text('暂无考试'))),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _list.length,
                itemBuilder: (_, i) {
                  final exam = _list[i];
                  final statusLabel = _statusLabel(exam);
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      leading: Icon(
                        statusLabel == '已完成'
                            ? Icons.check_circle
                            : statusLabel == '已过期'
                            ? Icons.lock
                            : Icons.quiz,
                        color: _statusColor(statusLabel),
                      ),
                      title: Text(
                        exam.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        statusLabel,
                        style: TextStyle(
                          color: _statusColor(statusLabel),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showDetail(exam),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
