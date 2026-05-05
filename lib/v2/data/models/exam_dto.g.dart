// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExamDtoImpl _$$ExamDtoImplFromJson(Map<String, dynamic> json) =>
    _$ExamDtoImpl(
      examId: json['examId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startTime: (json['startTime'] as num?)?.toInt() ?? 0,
      endTime: (json['endTime'] as num?)?.toInt() ?? 0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
      passScore: (json['passScore'] as num?)?.toInt() ?? 0,
      questionCount: (json['questionCount'] as num?)?.toInt() ?? 0,
      extras: json['extras'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ExamDtoImplToJson(_$ExamDtoImpl instance) =>
    <String, dynamic>{
      'examId': instance.examId,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'duration': instance.duration,
      'status': instance.status,
      'totalScore': instance.totalScore,
      'passScore': instance.passScore,
      'questionCount': instance.questionCount,
      'extras': instance.extras,
    };
