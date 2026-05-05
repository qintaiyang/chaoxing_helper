import 'package:fpdart/fpdart.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/remote/chaoxing/cx_todo_api.dart';
import '../mappers/todo_mapper.dart';
import '../models/todo_dto.dart';

class TodoRepositoryImpl implements TodoRepository {
  final CXTodoApi _cxApi;

  TodoRepositoryImpl(this._cxApi);

  @override
  Future<Either<Failure, TodoListResult>> getTodoList() async {
    try {
      final result = await _cxApi.getTodoList();
      if (result != null) {
        final data = result['data'];
        if (data is Map) {
          final todoItems = data['todoList'] ?? data['unDoneList'] ?? [];
          final doneItems = data['doneList'] ?? data['completedList'] ?? [];
          final todos = todoItems is List
              ? todoItems
                    .whereType<Map<String, dynamic>>()
                    .map((e) => TodoMapper.toEntity(TodoDto.fromJson(e)))
                    .toList()
              : <Todo>[];
          final doneTodos = doneItems is List
              ? doneItems
                    .whereType<Map<String, dynamic>>()
                    .map((e) => TodoMapper.toEntity(TodoDto.fromJson(e)))
                    .toList()
              : <Todo>[];
          return Right(TodoListResult(todos: todos, doneTodos: doneTodos));
        }
      }
      return const Left(Failure.business(message: '获取待办列表失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> pushTodo(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _cxApi.pushTodo(data);
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '推送待办失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Todo>> addTodo({
    required String title,
    String content = '',
    String courseid = '',
    String endtime = '',
    int remind = 0,
    int remindtype = 0,
  }) async {
    try {
      final result = await _cxApi.addTodo(
        title: title,
        content: content,
        courseid: courseid,
        endtime: endtime,
        remind: remind,
        remindtype: remindtype,
      );
      if (result != null) {
        return Right(TodoMapper.toEntity(result));
      }
      return const Left(Failure.business(message: '添加待办失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTodo({required String todoId}) async {
    try {
      final result = await _cxApi.deleteTodo(todoId: todoId);
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '删除待办失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, bool>> completeTodo({required String todoId}) async {
    try {
      final result = await _cxApi.completeTodo(todoId: todoId);
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '完成待办失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }
}
