import 'package:fpdart/fpdart.dart';
import '../repositories/todo_repository.dart';
import '../failures/failure.dart';

class GetTodoListUseCase {
  final TodoRepository _repo;
  GetTodoListUseCase(this._repo);

  Future<Either<Failure, TodoListResult>> execute() {
    return _repo.getTodoList();
  }
}
