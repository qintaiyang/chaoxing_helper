import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/homework.dart';
import '../providers/providers.dart';

part 'homework_controller.g.dart';

@riverpod
class HomeworkListController extends _$HomeworkListController {
  @override
  Future<List<HomeworkInfo>> build(
    String courseId,
    String classId,
    String cpi,
  ) async {
    final useCase = ref.read(getHomeworkListUseCaseProvider);
    final result = await useCase.execute(courseId, classId, cpi);
    return result.fold((failure) => throw failure, (homework) => homework);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
