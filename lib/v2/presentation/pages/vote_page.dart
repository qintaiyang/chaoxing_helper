import 'package:flutter/material.dart';
import '../../app_dependencies.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/error_state_widget.dart';

class VotePage extends StatefulWidget {
  final String activeId;
  final String classId;
  final String courseId;

  const VotePage({
    super.key,
    required this.activeId,
    required this.classId,
    required this.courseId,
  });

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  Map<String, dynamic>? _voteData;
  bool _loading = true;
  String? _error;
  String? _selectedOption;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadVoteDetail();
  }

  Future<void> _loadVoteDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await AppDependencies.instance.getQuizDetailUseCase.execute(
        activeId: widget.activeId,
        v2: false,
      );
      if (mounted) {
        result.fold(
          (f) => setState(() {
            _loading = false;
            _error = f.message;
          }),
          (data) => setState(() {
            _voteData = data;
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

  Future<void> _submitVote() async {
    if (_selectedOption == null) {
      _snack('请选择一个选项');
      return;
    }
    setState(() => _submitting = true);
    try {
      final questionId = _voteData?['questions']?.isNotEmpty == true
          ? _voteData!['questions'][0]['id']?.toString() ?? ''
          : '';

      final result = await AppDependencies.instance.submitVoteUseCase.execute(
        courseId: widget.courseId,
        classId: widget.classId,
        activeId: widget.activeId,
        questionId: questionId,
        answer: _selectedOption!,
      );
      if (mounted) {
        result.fold(
          (f) => _snack('提交失败: ${f.message}'),
          (data) {
            final success = data['result'] == 1 || data['status'] == 1;
            _snack(success ? '投票成功' : '投票失败: ${data['msg'] ?? '未知错误'}');
            if (success) {
              Navigator.of(context).pop();
            }
          },
        );
      }
    } catch (e) {
      if (mounted) _snack('提交失败: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _snack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('投票')),
      body: _loading
          ? const LoadingStateWidget(message: '正在加载投票...')
          : _error != null
          ? ErrorStateWidget(
              message: '加载失败: $_error',
              onRetry: _loadVoteDetail,
            )
          : _buildVoteContent(),
    );
  }

  Widget _buildVoteContent() {
    final voteData = _voteData;
    if (voteData == null) {
      return const Center(child: Text('暂无投票内容'));
    }

    final title = voteData['title']?.toString() ?? '投票';
    final questions = voteData['questions'] is List
        ? (voteData['questions'] as List)
        : <dynamic>[];

    if (questions.isEmpty) {
      return const Center(child: Text('暂无投票选项'));
    }

    final question = questions[0] is Map
        ? Map<String, dynamic>.from(questions[0] as Map)
        : <String, dynamic>{};
    final options = question['options'] is List
        ? (question['options'] as List)
            .map((o) => o.toString())
            .toList()
        : <String>[];

    return RefreshIndicator(
      onRefresh: _loadVoteDetail,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          if (voteData['description'] != null)
            Text(
              voteData['description'].toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 24),
          Text(
            question['question']?.toString() ?? '请选择',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ...List.generate(
            options.length,
            (index) => RadioListTile<String>(
              title: Text(options[index]),
              value: '$index',
              groupValue: _selectedOption,
              onChanged: (v) => setState(() => _selectedOption = v),
              dense: true,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : _submitVote,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('提交投票'),
            ),
          ),
        ],
      ),
    );
  }
}
