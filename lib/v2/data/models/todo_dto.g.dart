// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoDtoImpl _$$TodoDtoImplFromJson(Map<String, dynamic> json) =>
    _$TodoDtoImpl(
      todoId: json['todoId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      remind: (json['remind'] as num?)?.toInt() ?? 0,
      remindType: (json['remindType'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createTime: (json['createTime'] as num?)?.toInt() ?? 0,
      extras: json['extras'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$TodoDtoImplToJson(_$TodoDtoImpl instance) =>
    <String, dynamic>{
      'todoId': instance.todoId,
      'title': instance.title,
      'content': instance.content,
      'courseId': instance.courseId,
      'endTime': instance.endTime,
      'remind': instance.remind,
      'remindType': instance.remindType,
      'isCompleted': instance.isCompleted,
      'createTime': instance.createTime,
      'extras': instance.extras,
    };
