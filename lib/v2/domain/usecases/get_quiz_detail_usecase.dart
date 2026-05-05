import 'package:fpdart/fpdart.dart';
import '../repositories/quiz_repository.dart';
import '../failures/failure.dart';

class GetQuizDetailUseCase {
  final QuizRepository _repo;
  GetQuizDetailUseCase(this._repo);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String activeId,
    bool v2 = false,
  }) {
    return _repo.getQuizDetail(activeId: activeId, v2: v2);
  }
}
