import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_dto.freezed.dart';
part 'exam_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class ExamDto with _$ExamDto {
  const factory ExamDto({
    @Default('') String examId,
    @Default('') String title,
    @Default('') String description,
    @Default(0) int startTime,
    @Default(0) int endTime,
    @Default(0) int duration,
    @Default('') String status,
    @Default(0) int totalScore,
    @Default(0) int passScore,
    @Default(0) int questionCount,
    @Default({}) Map<String, dynamic> extras,
  }) = _ExamDto;

  factory ExamDto.fromJson(Map<String, dynamic> json) =>
      _$ExamDtoFromJson(json);
}
