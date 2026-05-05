import 'package:fpdart/fpdart.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/active.dart';
import '../../domain/entities/homework.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/remote/chaoxing/cx_course_api.dart';
import '../mappers/course_mapper.dart';
import '../mappers/active_mapper.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CXCourseApi _cxApi;

  CourseRepositoryImpl(this._cxApi);

  @override
  Future<Either<Failure, List<Course>>> getCourses() async {
    try {
      final dtos = await _cxApi.getCourses();
      final courses = <Course>[];
      for (final dto in dtos) {
        courses.add(dto.toEntity());
      }
      return Right(courses);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, List<Active>>> getActivities(
    String courseId,
    String classId,
    String cpi,
  ) async {
    try {
      final dtos = await _cxApi.getActivities(courseId, classId, cpi);
      final activities = <Active>[];
      for (final dto in dtos) {
        activities.add(dto.toEntity());
      }
      return Right(activities);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, List<HomeworkInfo>>> getHomeworkList(
    String courseId,
    String classId,
    String cpi,
  ) async {
    try {
      final dtos = await _cxApi.getHomeworkList(courseId, classId, cpi);
      final homework = <HomeworkInfo>[];
      for (final dto in dtos) {
        homework.add(
          HomeworkInfo(
            workId: dto.workId,
            courseId: dto.courseId,
            classId: dto.classId,
            cpi: dto.cpi,
            title: dto.title,
            status: dto.status,
            enc: dto.enc,
            answerId: dto.answerId,
            taskUrl: dto.taskUrl,
          ),
        );
      }
      return Right(homework);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCourseChapters(
    String courseId,
  ) async {
    return const Left(Failure.business(message: '课程章节功能暂未实现'));
  }
}
