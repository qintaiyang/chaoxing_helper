import 'package:fpdart/fpdart.dart';
import '../repositories/exam_repository.dart';
import '../failures/failure.dart';

class StartExamUseCase {
  final ExamRepository _examRepo;

  StartExamUseCase(this._examRepo);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String examId,
    required String courseId,
    required String classId,
  }) {
    return _examRepo.startExam(
      examId: examId,
      courseId: courseId,
      classId: classId,
    );
  }
}
