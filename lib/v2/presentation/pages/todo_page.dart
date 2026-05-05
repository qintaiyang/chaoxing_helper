import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/todo_controller.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoAsync = ref.watch(todoListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('待办')),
      body: todoAsync.when(
        loading: () => const LoadingStateWidget(message: '正在加载待办...'),
        error: (e, _) => ErrorStateWidget(
          message: '加载失败: $e',
          onRetry: () =>
              ref.read(todoListControllerProvider.notifier).refresh(),
        ),
        data: (result) {
          if (result.todos.isEmpty && result.doneTodos.isEmpty) {
            return const EmptyStateWidget(
              message: '暂无待办事项',
              icon: Icons.check_circle_outline,
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(todoListControllerProvider.notifier).refresh(),
            child: ListView(
              children: [
                if (result.todos.isNotEmpty) ...[
                  _SectionHeader(title: '未完成'),
                  ...result.todos.map(
                    (todo) => _TodoTile(
                      todo: todo,
                      onComplete: () => ref
                          .read(todoListControllerProvider.notifier)
                          .complete(todo.todoId),
                      onDelete: () => ref
                          .read(todoListControllerProvider.notifier)
                          .delete(todo.todoId),
                    ),
                  ),
                ],
                if (result.doneTodos.isNotEmpty) ...[
                  _SectionHeader(title: '已完成'),
                  ...result.doneTodos.map(
                    (todo) => _TodoTile(
                      todo: todo,
                      isCompleted: true,
                      onDelete: () => ref
                          .read(todoListControllerProvider.notifier)
                          .delete(todo.todoId),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _TodoTile extends StatelessWidget {
  final dynamic todo;
  final bool isCompleted;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;

  const _TodoTile({
    required this.todo,
    this.isCompleted = false,
    this.onComplete,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isCompleted ? Colors.green : Colors.grey,
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isCompleted ? Colors.grey : null,
        ),
      ),
      subtitle: Text(todo.endTime.isNotEmpty ? '截止: ${todo.endTime}' : ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isCompleted && onComplete != null)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: onComplete,
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个待办吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
