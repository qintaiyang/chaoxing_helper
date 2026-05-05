import 'package:fpdart/fpdart.dart';
import '../entities/active.dart';
import '../repositories/course_repository.dart';
import '../failures/failure.dart';

class GetActivitiesUseCase {
  final CourseRepository _courseRepo;

  GetActivitiesUseCase(this._courseRepo);

  Future<Either<Failure, List<Active>>> execute(
    String courseId,
    String classId,
    String cpi,
  ) {
    return _courseRepo.getActivities(courseId, classId, cpi);
  }
}
