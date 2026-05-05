import 'package:flutter/material.dart';
import '../../app_dependencies.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/error_state_widget.dart';

class QuestionnairePage extends StatefulWidget {
  final String activeId;
  final String classId;
  final String courseId;

  const QuestionnairePage({
    super.key,
    required this.activeId,
    required this.classId,
    required this.courseId,
  });

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  Map<String, dynamic>? _questionnaireData;
  bool _loading = true;
  String? _error;
  final Map<String, List<String>> _answers = {};
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadQuestionnaire();
  }

  Future<void> _loadQuestionnaire() async {
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
            _questionnaireData = data;
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

  Future<void> _submitQuestionnaire() async {
    if (_answers.isEmpty) {
      _snack('请至少回答一道题');
      return;
    }
    setState(() => _submitting = true);
    try {
      final result = await AppDependencies.instance
          .submitQuestionnaireUseCase
          .execute(
            courseId: widget.courseId,
            classId: widget.classId,
            activeId: widget.activeId,
            answers: _answers,
          );
      if (mounted) {
        result.fold(
          (f) => _snack('提交失败: ${f.message}'),
          (data) {
            final success = data['result'] == 1 || data['status'] == 1;
            _snack(success ? '问卷提交成功' : '提交失败: ${data['msg'] ?? '未知错误'}');
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
      appBar: AppBar(title: const Text('问卷')),
      body: _loading
          ? const LoadingStateWidget(message: '正在加载问卷...')
          : _error != null
          ? ErrorStateWidget(
              message: '加载失败: $_error',
              onRetry: _loadQuestionnaire,
            )
          : _buildQuestionnaireContent(),
    );
  }

  Widget _buildQuestionnaireContent() {
    final questionnaireData = _questionnaireData;
    if (questionnaireData == null) {
      return const Center(child: Text('暂无问卷内容'));
    }

    final title = questionnaireData['title']?.toString() ?? '问卷';
    final questions = questionnaireData['questions'] is List
        ? (questionnaireData['questions'] as List)
        : <dynamic>[];

    if (questions.isEmpty) {
      return const Center(child: Text('暂无问卷题目'));
    }

    return RefreshIndicator(
      onRefresh: _loadQuestionnaire,
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
          if (questionnaireData['description'] != null)
            Text(
              questionnaireData['description'].toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 24),
          ...List.generate(
            questions.length,
            (index) => _buildQuestionCard(questions[index], index + 1),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : _submitQuestionnaire,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('提交问卷'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(dynamic q, int index) {
    final question = q is Map ? Map<String, dynamic>.from(q) : <String, dynamic>{};
    final questionId = question['id']?.toString() ?? '';
    final questionText = question['question']?.toString() ?? '';
    final options = question['options'] is List
        ? (question['options'] as List).map((o) => o.toString()).toList()
        : <String>[];
    final isMultiple = question['type'] == 2 || question['multiple'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '第 $index 题${isMultiple ? '（多选）' : ''}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              questionText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            if (isMultiple)
              ...List.generate(
                options.length,
                (i) => CheckboxListTile(
                  title: Text(options[i]),
                  value: _answers[questionId]?.contains('$i') ?? false,
                  onChanged: (v) => setState(() {
                    final selected = _answers[questionId] ?? [];
                    if (v == true) {
                      selected.add('$i');
                    } else {
                      selected.remove('$i');
                    }
                    _answers[questionId] = selected;
                  }),
                  dense: true,
                ),
              )
            else
              ...List.generate(
                options.length,
                (i) => RadioListTile<String>(
                  title: Text(options[i]),
                  value: '$i',
                  groupValue: _answers[questionId]?.isNotEmpty == true
                      ? _answers[questionId]![0]
                      : null,
                  onChanged: (v) => setState(() {
                    if (v != null) {
                      _answers[questionId] = [v];
                    }
                  }),
                  dense: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
