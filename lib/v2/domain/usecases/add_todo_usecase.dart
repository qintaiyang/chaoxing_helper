import 'package:fpdart/fpdart.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';
import '../failures/failure.dart';

class AddTodoUseCase {
  final TodoRepository _todoRepo;

  AddTodoUseCase(this._todoRepo);

  Future<Either<Failure, Todo>> execute({
    required String title,
    String content = '',
    String courseid = '',
    String endtime = '',
    int remind = 0,
    int remindtype = 0,
  }) {
    return _todoRepo.addTodo(
      title: title,
      content: content,
      courseid: courseid,
      endtime: endtime,
      remind: remind,
      remindtype: remindtype,
    );
  }
}
