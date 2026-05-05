// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoticeDtoImpl _$$NoticeDtoImplFromJson(Map<String, dynamic> json) =>
    _$NoticeDtoImpl(
      noticeId: json['noticeId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      author: json['author'] as String? ?? '',
      createTime: (json['createTime'] as num?)?.toInt() ?? 0,
      isRead: json['isRead'] as bool? ?? false,
      courseId: json['courseId'] as String? ?? '',
      folderId: json['folderId'] as String? ?? '',
      extras: json['extras'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$NoticeDtoImplToJson(_$NoticeDtoImpl instance) =>
    <String, dynamic>{
      'noticeId': instance.noticeId,
      'title': instance.title,
      'content': instance.content,
      'author': instance.author,
      'createTime': instance.createTime,
      'isRead': instance.isRead,
      'courseId': instance.courseId,
      'folderId': instance.folderId,
      'extras': instance.extras,
    };
