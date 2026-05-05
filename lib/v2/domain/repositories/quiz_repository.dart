import 'package:fpdart/fpdart.dart';
import '../failures/failure.dart';

abstract class QuizRepository {
  Future<Either<Failure, bool>> checkQuizStatus({
    required String classId,
    required String activeId,
  });
  Future<Either<Failure, Map<String, dynamic>>> submitQuizAnswer({
    required String classId,
    required String courseId,
    required String activeId,
    required String answer,
  });
  Future<Either<Failure, Map<String, dynamic>>> getQuizDetail({
    required String activeId,
    bool v2,
  });
  Future<Either<Failure, Map<String, dynamic>>> submitVote({
    required String courseId,
    required String classId,
    required String activeId,
    required String questionId,
    required String answer,
  });
  Future<Either<Failure, Map<String, dynamic>>> submitQuestionnaire({
    required String courseId,
    required String classId,
    required String activeId,
    required Map<String, List<String>> answers,
  });
}
