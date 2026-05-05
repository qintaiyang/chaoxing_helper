import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_dto.freezed.dart';
part 'quiz_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class QuizDto with _$QuizDto {
  const factory QuizDto({
    @Default('') String quizId,
    @Default('') String title,
    @Default('') String description,
    @Default(0) int type,
    @Default(0) int startTime,
    @Default(0) int endTime,
    @Default(false) bool isAnswer,
    @Default(0) int questionCount,
    @Default({}) Map<String, dynamic> extras,
  }) = _QuizDto;

  factory QuizDto.fromJson(Map<String, dynamic> json) =>
      _$QuizDtoFromJson(json);
}
