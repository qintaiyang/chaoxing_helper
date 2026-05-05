import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/failures/failure.dart';
import '../providers/providers.dart';

part 'quiz_controller.g.dart';

@riverpod
class QuizDetailController extends _$QuizDetailController {
  @override
  Future<Map<String, dynamic>> build(String activeId) async {
    final useCase = ref.read(getQuizDetailUseCaseProvider);
    final result = await useCase.execute(activeId: activeId);
    return result.fold((failure) => throw failure, (data) => data);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class QuizStatusController extends _$QuizStatusController {
  @override
  Future<bool> build(String classId, String activeId) async {
    final useCase = ref.read(checkQuizStatusUseCaseProvider);
    final result = await useCase.execute(classId: classId, activeId: activeId);
    return result.fold((failure) => throw failure, (status) => status);
  }
}

@riverpod
class QuizSubmitController extends _$QuizSubmitController {
  @override
  Future<Map<String, dynamic>> build() async {
    return {};
  }

  Future<bool> submit({
    required String classId,
    required String courseId,
    required String activeId,
    required String answer,
  }) async {
    final useCase = ref.read(submitQuizAnswerUseCaseProvider);
    final result = await useCase.execute(
      classId: classId,
      courseId: courseId,
      activeId: activeId,
      answer: answer,
    );
    return result.fold(
      (failure) {
        state = AsyncError(
          Failure.business(message: '提交失败'),
          StackTrace.current,
        );
        return false;
      },
      (data) {
        state = AsyncData({});
        return true;
      },
    );
  }
}
