import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/todo_repository.dart';
import '../providers/providers.dart';

part 'todo_controller.g.dart';

@riverpod
class TodoListController extends _$TodoListController {
  @override
  Future<TodoListResult> build() async {
    final useCase = ref.read(getTodoListUseCaseProvider);
    final result = await useCase.execute();
    return result.fold((failure) => throw failure, (data) => data);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<bool> complete(String todoId) async {
    final useCase = ref.read(completeTodoUseCaseProvider);
    final result = await useCase.execute(todoId);
    return result.fold((failure) => false, (success) {
      if (success) refresh();
      return success;
    });
  }

  Future<bool> delete(String todoId) async {
    final useCase = ref.read(deleteTodoUseCaseProvider);
    final result = await useCase.execute(todoId);
    return result.fold((failure) => false, (success) {
      if (success) refresh();
      return success;
    });
  }
}
