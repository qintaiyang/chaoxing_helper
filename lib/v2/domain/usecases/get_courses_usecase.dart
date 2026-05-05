import 'package:fpdart/fpdart.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';
import '../failures/failure.dart';

class GetCoursesUseCase {
  final CourseRepository _courseRepo;

  GetCoursesUseCase(this._courseRepo);

  Future<Either<Failure, List<Course>>> execute() {
    return _courseRepo.getCourses();
  }
}
