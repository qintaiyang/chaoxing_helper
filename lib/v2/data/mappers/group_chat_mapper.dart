import '../../domain/entities/group_chat.dart';
import '../models/group_chat_dto.dart';

class GroupChatMapper {
  static GroupChat toEntity(GroupChatDto dto) {
    return GroupChat(
      chatId: dto.chatId,
      chatName: dto.chatName,
      chatIco: dto.chatIco,
      isGroup: dto.isGroup,
      isPrivate: dto.isPrivate,
      count: dto.count,
      level: dto.level,
      createTime: dto.createTime,
      updateTime: dto.updateTime,
    );
  }

  static List<GroupChat> toEntityList(List<GroupChatDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}

class GroupMemberMapper {
  static GroupMember toEntity(GroupMemberDto dto) {
    return GroupMember(
      tuid: dto.tuid,
      puid: dto.puid,
      name: dto.name,
      picUrl: dto.picUrl,
    );
  }

  static List<GroupMember> toEntityList(List<GroupMemberDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}

class GroupMessageMapper {
  static GroupMessage toEntity(GroupMessageDto dto) {
    return GroupMessage(
      msgId: dto.msgId,
      from: dto.from,
      to: dto.to,
      content: dto.content,
      msgType: dto.msgType,
      timestamp: dto.timestamp,
    );
  }

  static List<GroupMessage> toEntityList(List<GroupMessageDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}
