import 'package:fpdart/fpdart.dart';
import '../repositories/quiz_repository.dart';
import '../failures/failure.dart';

class SubmitVoteUseCase {
  final QuizRepository _quizRepo;

  SubmitVoteUseCase(this._quizRepo);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String courseId,
    required String classId,
    required String activeId,
    required String questionId,
    required String answer,
  }) {
    return _quizRepo.submitVote(
      courseId: courseId,
      classId: classId,
      activeId: activeId,
      questionId: questionId,
      answer: answer,
    );
  }
}
