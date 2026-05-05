import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_dto.freezed.dart';
part 'course_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class CourseDto with _$CourseDto {
  const factory CourseDto({
    @Default('') String courseId,
    @Default('') String clazzId,
    @Default('') String? cpi,
    @Default('') String image,
    @Default('') String name,
    @Default('') String teacher,
    @Default(true) bool state,
    @Default('') String? note,
    @Default('') String? schools,
    @Default('') String? beginDate,
    @Default('') String? endDate,
    @Default('') String? lessonId,
    CourseSettingsDto? settings,
  }) = _CourseDto;

  factory CourseDto.fromJson(Map<String, dynamic> json) =>
      _$CourseDtoFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class CourseSettingsDto with _$CourseSettingsDto {
  const factory CourseSettingsDto({
    CourseLocationDto? location,
    @Default([]) List<String> imageObjectIds,
  }) = _CourseSettingsDto;

  factory CourseSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$CourseSettingsDtoFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class CourseLocationDto with _$CourseLocationDto {
  const factory CourseLocationDto({
    String? classroom,
    @Default('') String address,
    @Default('') String latitude,
    @Default('') String longitude,
  }) = _CourseLocationDto;

  factory CourseLocationDto.fromJson(Map<String, dynamic> json) =>
      _$CourseLocationDtoFromJson(json);
}
