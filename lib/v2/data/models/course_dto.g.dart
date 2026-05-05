// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseDtoImpl _$$CourseDtoImplFromJson(Map<String, dynamic> json) =>
    _$CourseDtoImpl(
      courseId: json['courseId'] as String? ?? '',
      clazzId: json['clazzId'] as String? ?? '',
      cpi: json['cpi'] as String? ?? '',
      image: json['image'] as String? ?? '',
      name: json['name'] as String? ?? '',
      teacher: json['teacher'] as String? ?? '',
      state: json['state'] as bool? ?? true,
      note: json['note'] as String? ?? '',
      schools: json['schools'] as String? ?? '',
      beginDate: json['beginDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      lessonId: json['lessonId'] as String? ?? '',
      settings: json['settings'] == null
          ? null
          : CourseSettingsDto.fromJson(
              json['settings'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$CourseDtoImplToJson(_$CourseDtoImpl instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'clazzId': instance.clazzId,
      'cpi': instance.cpi,
      'image': instance.image,
      'name': instance.name,
      'teacher': instance.teacher,
      'state': instance.state,
      'note': instance.note,
      'schools': instance.schools,
      'beginDate': instance.beginDate,
      'endDate': instance.endDate,
      'lessonId': instance.lessonId,
      'settings': instance.settings,
    };

_$CourseSettingsDtoImpl _$$CourseSettingsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CourseSettingsDtoImpl(
  location: json['location'] == null
      ? null
      : CourseLocationDto.fromJson(json['location'] as Map<String, dynamic>),
  imageObjectIds:
      (json['imageObjectIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CourseSettingsDtoImplToJson(
  _$CourseSettingsDtoImpl instance,
) => <String, dynamic>{
  'location': instance.location,
  'imageObjectIds': instance.imageObjectIds,
};

_$CourseLocationDtoImpl _$$CourseLocationDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CourseLocationDtoImpl(
  classroom: json['classroom'] as String?,
  address: json['address'] as String? ?? '',
  latitude: json['latitude'] as String? ?? '',
  longitude: json['longitude'] as String? ?? '',
);

Map<String, dynamic> _$$CourseLocationDtoImplToJson(
  _$CourseLocationDtoImpl instance,
) => <String, dynamic>{
  'classroom': instance.classroom,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
