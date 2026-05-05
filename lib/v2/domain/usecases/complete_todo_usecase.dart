import 'package:fpdart/fpdart.dart';
import '../repositories/todo_repository.dart';
import '../failures/failure.dart';

class CompleteTodoUseCase {
  final TodoRepository _repo;
  CompleteTodoUseCase(this._repo);

  Future<Either<Failure, bool>> execute(String todoId) {
    return _repo.completeTodo(todoId: todoId);
  }
}
