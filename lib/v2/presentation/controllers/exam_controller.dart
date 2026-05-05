import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/exam.dart';
import '../providers/providers.dart';

part 'exam_controller.g.dart';

@riverpod
class ExamListController extends _$ExamListController {
  @override
  Future<List<Exam>> build(String courseId, String classId) async {
    final useCase = ref.read(getExamListUseCaseProvider);
    final result = await useCase.execute(courseId: courseId, classId: classId);
    return result.fold((failure) => throw failure, (exams) => exams);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
