class GroupChat {
  final String chatId;
  final String chatName;
  final String chatIco;
  final bool isGroup;
  final bool isPrivate;
  final int count;
  final int level;
  final int createTime;
  final int updateTime;

  const GroupChat({
    required this.chatId,
    required this.chatName,
    this.chatIco = '',
    this.isGroup = false,
    this.isPrivate = false,
    this.count = 0,
    this.level = 0,
    this.createTime = 0,
    this.updateTime = 0,
  });

  GroupChat copyWith({
    String? chatId,
    String? chatName,
    String? chatIco,
    bool? isGroup,
    bool? isPrivate,
    int? count,
    int? level,
    int? createTime,
    int? updateTime,
  }) {
    return GroupChat(
      chatId: chatId ?? this.chatId,
      chatName: chatName ?? this.chatName,
      chatIco: chatIco ?? this.chatIco,
      isGroup: isGroup ?? this.isGroup,
      isPrivate: isPrivate ?? this.isPrivate,
      count: count ?? this.count,
      level: level ?? this.level,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }
}

class GroupMember {
  final String tuid;
  final String puid;
  final String name;
  final String picUrl;

  const GroupMember({
    required this.tuid,
    required this.puid,
    this.name = '',
    this.picUrl = '',
  });

  String getSafePicUrl() {
    if (picUrl.startsWith('http://')) {
      return picUrl.replaceFirst('http://', 'https://');
    }
    return picUrl;
  }
}

class GroupMessage {
  final String msgId;
  final String from;
  final String to;
  final String content;
  final String msgType;
  final int timestamp;

  const GroupMessage({
    required this.msgId,
    required this.from,
    required this.to,
    required this.content,
    this.msgType = 'text',
    this.timestamp = 0,
  });
}
