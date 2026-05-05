import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/active.dart';
import '../../app_dependencies.dart';

part 'course_controller.g.dart';

@riverpod
class CourseListController extends _$CourseListController {
  @override
  Future<List<Course>> build() async {
    final result = await AppDependencies.instance.getCoursesUseCase.execute();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (courses) => courses,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class ActivityListController extends _$ActivityListController {
  @override
  Future<List<Active>> build() async => [];

  Future<void> loadActivities(
    String courseId,
    String classId,
    String cpi,
  ) async {
    state = const AsyncValue.loading();
    try {
      final result = await AppDependencies.instance.getActivitiesUseCase
          .execute(courseId, classId, cpi);
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (activities) => state = AsyncValue.data(activities),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
