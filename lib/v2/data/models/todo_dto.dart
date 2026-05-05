import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_dto.freezed.dart';
part 'todo_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class TodoDto with _$TodoDto {
  const factory TodoDto({
    @Default('') String todoId,
    @Default('') String title,
    @Default('') String content,
    @Default('') String courseId,
    @Default('') String endTime,
    @Default(0) int remind,
    @Default(0) int remindType,
    @Default(false) bool isCompleted,
    @Default(0) int createTime,
    @Default({}) Map<String, dynamic> extras,
  }) = _TodoDto;

  factory TodoDto.fromJson(Map<String, dynamic> json) =>
      _$TodoDtoFromJson(json);
}
