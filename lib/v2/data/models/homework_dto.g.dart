// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homework_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeworkDtoImpl _$$HomeworkDtoImplFromJson(Map<String, dynamic> json) =>
    _$HomeworkDtoImpl(
      workId: json['workId'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      classId: json['classId'] as String? ?? '',
      cpi: json['cpi'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      enc: json['enc'] as String? ?? '',
      answerId: json['answerId'] as String? ?? '',
      taskUrl: json['taskUrl'] as String? ?? '',
    );

Map<String, dynamic> _$$HomeworkDtoImplToJson(_$HomeworkDtoImpl instance) =>
    <String, dynamic>{
      'workId': instance.workId,
      'courseId': instance.courseId,
      'classId': instance.classId,
      'cpi': instance.cpi,
      'title': instance.title,
      'status': instance.status,
      'enc': instance.enc,
      'answerId': instance.answerId,
      'taskUrl': instance.taskUrl,
    };
