import 'package:fpdart/fpdart.dart';
import '../repositories/quiz_repository.dart';
import '../failures/failure.dart';

class SubmitQuestionnaireUseCase {
  final QuizRepository _quizRepo;

  SubmitQuestionnaireUseCase(this._quizRepo);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String courseId,
    required String classId,
    required String activeId,
    required Map<String, List<String>> answers,
  }) {
    return _quizRepo.submitQuestionnaire(
      courseId: courseId,
      classId: classId,
      activeId: activeId,
      answers: answers,
    );
  }
}
