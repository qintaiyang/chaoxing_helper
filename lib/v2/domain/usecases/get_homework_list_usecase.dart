import 'package:fpdart/fpdart.dart';
import '../entities/homework.dart';
import '../repositories/course_repository.dart';
import '../failures/failure.dart';

class GetHomeworkListUseCase {
  final CourseRepository _courseRepo;

  GetHomeworkListUseCase(this._courseRepo);

  Future<Either<Failure, List<HomeworkInfo>>> execute(
    String courseId,
    String classId,
    String cpi,
  ) {
    return _courseRepo.getHomeworkList(courseId, classId, cpi);
  }
}
