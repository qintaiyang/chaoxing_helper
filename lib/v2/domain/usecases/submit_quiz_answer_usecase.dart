import 'package:fpdart/fpdart.dart';
import '../repositories/quiz_repository.dart';
import '../failures/failure.dart';

class SubmitQuizAnswerUseCase {
  final QuizRepository _quizRepo;

  SubmitQuizAnswerUseCase(this._quizRepo);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String classId,
    required String courseId,
    required String activeId,
    required String answer,
  }) {
    return _quizRepo.submitQuizAnswer(
      classId: classId,
      courseId: courseId,
      activeId: activeId,
      answer: answer,
    );
  }
}
