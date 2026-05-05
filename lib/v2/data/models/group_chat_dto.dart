import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_chat_dto.freezed.dart';
part 'group_chat_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class GroupChatDto with _$GroupChatDto {
  const factory GroupChatDto({
    @Default('') String chatId,
    @Default('') String chatName,
    @Default('') String chatIco,
    @Default(false) bool isGroup,
    @Default(false) bool isPrivate,
    @Default(0) int count,
    @Default(0) int level,
    @Default(0) int subFolder,
    @Default(false) bool folder,
    @Default(0) int createTime,
    @Default(0) int updateTime,
    @Default([]) List<String> picArray,
  }) = _GroupChatDto;

  factory GroupChatDto.fromJson(Map<String, dynamic> json) =>
      _$GroupChatDtoFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class GroupMessageDto with _$GroupMessageDto {
  const factory GroupMessageDto({
    @Default('') String msgId,
    @Default('') String from,
    @Default('') String to,
    @Default('') String content,
    @Default('text') String msgType,
    @Default(0) int timestamp,
    @Default({}) Map<String, dynamic> extras,
  }) = _GroupMessageDto;

  factory GroupMessageDto.fromJson(Map<String, dynamic> json) =>
      _$GroupMessageDtoFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class GroupMemberDto with _$GroupMemberDto {
  const factory GroupMemberDto({
    @Default('') String tuid,
    @Default('') String puid,
    @Default('') String name,
    @Default('') String picUrl,
  }) = _GroupMemberDto;

  factory GroupMemberDto.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberDtoFromJson({
        'tuid': (json['tuid'] ?? json['uid'] ?? '').toString(),
        'puid': (json['puid'] ?? '').toString(),
        'name': (json['name'] ?? json['userName'] ?? json['nickName'] ?? '')
            .toString(),
        'picUrl': (json['picUrl'] ?? json['pic'] ?? '').toString(),
      });
}
