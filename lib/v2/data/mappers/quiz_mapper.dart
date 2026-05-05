import '../../domain/entities/quiz.dart';
import '../models/quiz_dto.dart';

class QuizMapper {
  static Quiz toEntity(
    QuizDto dto, {
    String courseId = '',
    String classId = '',
  }) {
    return Quiz(
      quizId: dto.quizId,
      courseId: dto.extras['courseId']?.toString() ?? courseId,
      classId: dto.extras['classId']?.toString() ?? classId,
      title: dto.title,
      description: dto.description,
      type: dto.type,
      startTime: dto.startTime,
      endTime: dto.endTime,
      isAnswer: dto.isAnswer,
      questionCount: dto.questionCount,
    );
  }

  static List<Quiz> toEntityList(
    List<QuizDto> dtos, {
    String courseId = '',
    String classId = '',
  }) {
    return dtos
        .map((dto) => toEntity(dto, courseId: courseId, classId: classId))
        .toList();
  }
}
