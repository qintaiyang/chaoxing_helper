import 'package:fpdart/fpdart.dart';
import '../repositories/todo_repository.dart';
import '../failures/failure.dart';

class DeleteTodoUseCase {
  final TodoRepository _repo;
  DeleteTodoUseCase(this._repo);

  Future<Either<Failure, bool>> execute(String todoId) {
    return _repo.deleteTodo(todoId: todoId);
  }
}
