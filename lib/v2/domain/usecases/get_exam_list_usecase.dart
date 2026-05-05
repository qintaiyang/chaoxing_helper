import 'package:fpdart/fpdart.dart';
import '../entities/exam.dart';
import '../repositories/exam_repository.dart';
import '../failures/failure.dart';

class GetExamListUseCase {
  final ExamRepository _examRepo;

  GetExamListUseCase(this._examRepo);

  Future<Either<Failure, List<Exam>>> execute({
    required String courseId,
    required String classId,
    int page = 1,
    int pageSize = 20,
  }) {
    return _examRepo.getExamList(
      courseId: courseId,
      classId: classId,
      page: page,
      pageSize: pageSize,
    );
  }
}
