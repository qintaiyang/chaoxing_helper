import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../../app_dependencies.dart';

class QuizPage extends ConsumerStatefulWidget {
  final String activeId;
  final String classId;
  final String courseId;

  const QuizPage({
    super.key,
    required this.activeId,
    required this.classId,
    required this.courseId,
  });

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  final Map<int, String> _answers = {};
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizDetailControllerProvider(widget.activeId));

    return Scaffold(
      appBar: AppBar(title: const Text('测验')),
      body: quizAsync.when(
        loading: () => const LoadingStateWidget(message: '正在加载测验...'),
        error: (e, _) => ErrorStateWidget(
          message: '加载失败: $e',
          onRetry: () => ref
              .read(quizDetailControllerProvider(widget.activeId).notifier)
              .refresh(),
        ),
        data: (quiz) {
          if (quiz.isEmpty) {
            return const EmptyStateWidget(message: '暂无测验内容');
          }
          final questions = quiz['questions'] is List
              ? quiz['questions'] as List
              : <dynamic>[];

          return RefreshIndicator(
            onRefresh: () => ref
                .read(quizDetailControllerProvider(widget.activeId).notifier)
                .refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  quiz['title']?.toString() ?? '测验',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                if (quiz['description'] != null)
                  Text(
                    quiz['description'].toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 24),
                ...List.generate(questions.length, (index) {
                  final q = questions[index] is Map
                      ? Map<String, dynamic>.from(questions[index] as Map)
                      : <String, dynamic>{};
                  return _QuestionCard(
                    question: q,
                    index: index + 1,
                    selectedValue: _answers[index],
                    onChanged: (v) => setState(() => _answers[index] = v ?? ''),
                  );
                }),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submitting ? null : () => _submitQuiz(),
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('提交答案'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitQuiz() async {
    if (_answers.isEmpty) {
      _snack('请至少选择一道题的答案');
      return;
    }
    setState(() => _submitting = true);
    try {
      final answer = _answers.entries
          .map((e) => '${e.key}:${e.value}')
          .join(';');
      final result = await AppDependencies.instance.submitQuizAnswerUseCase
          .execute(
            classId: widget.classId,
            courseId: widget.courseId,
            activeId: widget.activeId,
            answer: answer,
          );
      result.fold((f) => _snack('提交失败: ${f.message}'), (_) => _snack('提交成功'));
    } catch (e) {
      _snack('提交失败: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _snack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}

class _QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final int index;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const _QuestionCard({
    required this.question,
    required this.index,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final opts = question['options'] is List
        ? (question['options'] as List).map((o) => o.toString()).toList()
        : <String>[];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('第 $index 题', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              question['question']?.toString() ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            ...List.generate(
              opts.length,
              (i) => RadioListTile<String>(
                title: Text(opts[i]),
                value: '$i',
                groupValue: selectedValue,
                onChanged: onChanged,
                dense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
