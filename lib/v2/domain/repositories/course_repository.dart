import 'package:fpdart/fpdart.dart';
import '../entities/course.dart';
import '../entities/active.dart';
import '../entities/homework.dart';
import '../failures/failure.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getCourses();
  Future<Either<Failure, List<Active>>> getActivities(
    String courseId,
    String classId,
    String cpi,
  );
  Future<Either<Failure, List<HomeworkInfo>>> getHomeworkList(
    String courseId,
    String classId,
    String cpi,
  );
  Future<Either<Failure, Map<String, dynamic>>> getCourseChapters(
    String courseId,
  );
}
