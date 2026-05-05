import 'package:flutter/material.dart';
import '../../app_dependencies.dart';
import '../../domain/entities/notice.dart';

class NoticeListPage extends StatefulWidget {
  final String courseId;
  const NoticeListPage({super.key, required this.courseId});

  @override
  State<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  List<Notice> _items = [];
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
      final result = await AppDependencies.instance.getCourseNoticesUseCase
          .execute(courseId: widget.courseId);
      if (mounted)
        result.fold(
          (f) => setState(() {
            _loading = false;
            _error = f.message;
          }),
          (list) => setState(() {
            _items = list;
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

  String _formatTime(dynamic ts) {
    if (ts == null) return '';
    final t = ts is int ? ts : int.tryParse(ts.toString()) ?? 0;
    if (t == 0) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(t);
    return '${d.month}/${d.day} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('课程通知')),
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
          : _items.isEmpty
          ? RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                children: const [
                  SizedBox(height: 200, child: Center(child: Text('暂无通知'))),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _items.length,
                itemBuilder: (_, i) {
                  final n = _items[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      leading: Icon(
                        n.isRead ? Icons.drafts : Icons.email,
                        color: n.isRead
                            ? Colors.grey
                            : theme.colorScheme.primary,
                      ),
                      title: Text(
                        n.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            '${n.author} · ${_formatTime(n.createTime)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 18),
                      onTap: () => _showDetail(n),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _showDetail(Notice n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(n.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${n.author} · ${_formatTime(n.createTime)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Divider(),
              Text(n.content),
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
}
