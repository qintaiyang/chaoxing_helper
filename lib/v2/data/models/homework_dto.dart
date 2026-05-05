import 'package:freezed_annotation/freezed_annotation.dart';

part 'homework_dto.freezed.dart';
part 'homework_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class HomeworkDto with _$HomeworkDto {
  const factory HomeworkDto({
    @Default('') String workId,
    @Default('') String courseId,
    @Default('') String classId,
    @Default('') String cpi,
    @Default('') String title,
    @Default('') String status,
    @Default('') String enc,
    @Default('') String answerId,
    @Default('') String taskUrl,
  }) = _HomeworkDto;

  factory HomeworkDto.fromJson(Map<String, dynamic> json) =>
      _$HomeworkDtoFromJson(json);
}
