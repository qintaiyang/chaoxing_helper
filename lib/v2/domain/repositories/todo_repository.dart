import 'package:fpdart/fpdart.dart';
import '../entities/todo.dart';
import '../failures/failure.dart';

class TodoListResult {
  final List<Todo> todos;
  final List<Todo> doneTodos;
  TodoListResult({required this.todos, required this.doneTodos});
}

abstract class TodoRepository {
  Future<Either<Failure, TodoListResult>> getTodoList();
  Future<Either<Failure, Map<String, dynamic>>> pushTodo(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, Todo>> addTodo({
    required String title,
    String content,
    String courseid,
    String endtime,
    int remind,
    int remindtype,
  });
  Future<Either<Failure, bool>> deleteTodo({required String todoId});
  Future<Either<Failure, bool>> completeTodo({required String todoId});
}
