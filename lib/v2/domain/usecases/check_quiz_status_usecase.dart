import 'package:fpdart/fpdart.dart';
import '../repositories/quiz_repository.dart';
import '../failures/failure.dart';

class CheckQuizStatusUseCase {
  final QuizRepository _repo;
  CheckQuizStatusUseCase(this._repo);

  Future<Either<Failure, bool>> execute({
    required String classId,
    required String activeId,
  }) {
    return _repo.checkQuizStatus(classId: classId, activeId: activeId);
  }
}
