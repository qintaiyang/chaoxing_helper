// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizDtoImpl _$$QuizDtoImplFromJson(Map<String, dynamic> json) =>
    _$QuizDtoImpl(
      quizId: json['quizId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: (json['type'] as num?)?.toInt() ?? 0,
      startTime: (json['startTime'] as num?)?.toInt() ?? 0,
      endTime: (json['endTime'] as num?)?.toInt() ?? 0,
      isAnswer: json['isAnswer'] as bool? ?? false,
      questionCount: (json['questionCount'] as num?)?.toInt() ?? 0,
      extras: json['extras'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$QuizDtoImplToJson(_$QuizDtoImpl instance) =>
    <String, dynamic>{
      'quizId': instance.quizId,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isAnswer': instance.isAnswer,
      'questionCount': instance.questionCount,
      'extras': instance.extras,
    };
