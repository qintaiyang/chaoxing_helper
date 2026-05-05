// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_chat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupChatDtoImpl _$$GroupChatDtoImplFromJson(Map<String, dynamic> json) =>
    _$GroupChatDtoImpl(
      chatId: json['chatId'] as String? ?? '',
      chatName: json['chatName'] as String? ?? '',
      chatIco: json['chatIco'] as String? ?? '',
      isGroup: json['isGroup'] as bool? ?? false,
      isPrivate: json['isPrivate'] as bool? ?? false,
      count: (json['count'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 0,
      subFolder: (json['subFolder'] as num?)?.toInt() ?? 0,
      folder: json['folder'] as bool? ?? false,
      createTime: (json['createTime'] as num?)?.toInt() ?? 0,
      updateTime: (json['updateTime'] as num?)?.toInt() ?? 0,
      picArray:
          (json['picArray'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GroupChatDtoImplToJson(_$GroupChatDtoImpl instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'chatName': instance.chatName,
      'chatIco': instance.chatIco,
      'isGroup': instance.isGroup,
      'isPrivate': instance.isPrivate,
      'count': instance.count,
      'level': instance.level,
      'subFolder': instance.subFolder,
      'folder': instance.folder,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'picArray': instance.picArray,
    };

_$GroupMessageDtoImpl _$$GroupMessageDtoImplFromJson(
  Map<String, dynamic> json,
) => _$GroupMessageDtoImpl(
  msgId: json['msgId'] as String? ?? '',
  from: json['from'] as String? ?? '',
  to: json['to'] as String? ?? '',
  content: json['content'] as String? ?? '',
  msgType: json['msgType'] as String? ?? 'text',
  timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
  extras: json['extras'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$GroupMessageDtoImplToJson(
  _$GroupMessageDtoImpl instance,
) => <String, dynamic>{
  'msgId': instance.msgId,
  'from': instance.from,
  'to': instance.to,
  'content': instance.content,
  'msgType': instance.msgType,
  'timestamp': instance.timestamp,
  'extras': instance.extras,
};

_$GroupMemberDtoImpl _$$GroupMemberDtoImplFromJson(Map<String, dynamic> json) =>
    _$GroupMemberDtoImpl(
      tuid: json['tuid'] as String? ?? '',
      puid: json['puid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      picUrl: json['picUrl'] as String? ?? '',
    );

Map<String, dynamic> _$$GroupMemberDtoImplToJson(
  _$GroupMemberDtoImpl instance,
) => <String, dynamic>{
  'tuid': instance.tuid,
  'puid': instance.puid,
  'name': instance.name,
  'picUrl': instance.picUrl,
};
