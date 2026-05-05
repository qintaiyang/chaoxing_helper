import '../../domain/entities/course.dart';
import '../models/course_dto.dart';

extension CourseDtoX on CourseDto {
  Course toEntity() => Course(
    courseId: courseId,
    classId: clazzId,
    cpi: cpi,
    image: image,
    name: name,
    teacher: teacher,
    state: state,
    note: note,
    schools: schools,
    beginDate: beginDate,
    endDate: endDate,
    lessonId: lessonId,
    settings: settings?.toEntity(),
  );
}

extension CourseSettingsDtoX on CourseSettingsDto {
  CourseSettings toEntity() => CourseSettings(
    location: location?.toEntity(),
    imageObjectIds: imageObjectIds,
  );
}

extension CourseLocationDtoX on CourseLocationDto {
  CourseLocation toEntity() => CourseLocation(
    classroom: classroom,
    address: address,
    latitude: latitude,
    longitude: longitude,
  );
}
