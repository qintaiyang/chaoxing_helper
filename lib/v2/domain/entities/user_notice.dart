import 'dart:convert';

class UserNotice {
  final String id;
  final String title;
  final String content;
  final String rtfContent;
  final int isread;
  final String creater;
  final String createrName;
  final int sourceType;
  final String sourceName;
  final int createTime;
  final int sendTime;
  final List<UserNoticeAttachment> attachments;

  const UserNotice({
    required this.id,
    required this.title,
    required this.content,
    required this.rtfContent,
    required this.isread,
    required this.creater,
    required this.createrName,
    required this.sourceType,
    required this.sourceName,
    required this.createTime,
    required this.sendTime,
    this.attachments = const [],
  });

  factory UserNotice.fromJson(Map<String, dynamic> json) {
    List<UserNoticeAttachment> parseAttachments() {
      final attachment = json['attachment'];
      if (attachment == null || attachment.isEmpty) return [];

      if (attachment is List) {
        return attachment
            .whereType<Map<String, dynamic>>()
            .map(UserNoticeAttachment.fromJson)
            .toList();
      }

      if (attachment is String && attachment.isNotEmpty) {
        List<UserNoticeAttachment> tryParseJson(String str) {
          try {
            String cleaned = str.trim();
            if (cleaned.startsWith('[')) {
              final decoded = jsonDecode(cleaned) as List<dynamic>;
              return decoded
                  .whereType<Map<String, dynamic>>()
                  .map(UserNoticeAttachment.fromJson)
                  .toList();
            } else if (cleaned.startsWith('{')) {
              final decoded = jsonDecode(cleaned) as Map<String, dynamic>;
              return [UserNoticeAttachment.fromJson(decoded)];
            }
          } catch (e) {
            // Try to fix common JSON issues
            try {
              String fixed = str.trim();
              fixed = fixed.replaceAll('&#39;', "'");
              fixed = fixed.replaceAll('&quot;', '"');
              fixed = fixed.replaceAll('&amp;', '&');
              fixed = fixed.replaceAll('&lt;', '<');
              fixed = fixed.replaceAll('&gt;', '>');

              final decoded = jsonDecode(fixed);
              if (decoded is List) {
                return decoded
                    .whereType<Map<String, dynamic>>()
                    .map(UserNoticeAttachment.fromJson)
                    .toList();
              } else if (decoded is Map<String, dynamic>) {
                return [UserNoticeAttachment.fromJson(decoded)];
              }
            } catch (_) {}
          }
          return [];
        }

        final result = tryParseJson(attachment);
        if (result.isNotEmpty) return result;

        // Try pipe-separated format
        try {
          final pipeSplit = attachment.split('|');
          for (final segment in pipeSplit) {
            final parsed = tryParseJson(segment);
            if (parsed.isNotEmpty) return parsed;
          }
        } catch (_) {}
      }
      return [];
    }

    return UserNotice(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      rtfContent: json['rtfContent']?.toString() ?? '',
      isread: int.tryParse(json['isread']?.toString() ?? '0') ?? 0,
      creater: json['creater']?.toString() ?? '',
      createrName: json['createrName']?.toString() ?? '',
      sourceType: int.tryParse(json['sourceType']?.toString() ?? '0') ?? 0,
      sourceName: json['sourceName']?.toString() ?? '',
      createTime: int.tryParse(json['createTime']?.toString() ?? '0') ?? 0,
      sendTime: int.tryParse(json['sendTime']?.toString() ?? '0') ?? 0,
      attachments: parseAttachments(),
    );
  }

  String getSourceTypeDescription() {
    switch (sourceType) {
      case 14:
        return '任务点通知';
      case 19:
        return '测验通知';
      case 4:
      case 54:
        return '签到通知';
      case 1:
      case 45:
        return '通知';
      case 2:
        return '资料通知';
      case 11:
        return '好友通知';
      case 43:
        return '投票通知';
      case 5:
        return '讨论通知';
      case 42:
        return '作业通知';
      case 23:
        return '星级通知';
      case 17:
        return '视频通知';
      case 61:
        return '人脸识别通知';
      case 68:
        return '游戏通知';
      default:
        return '其他通知';
    }
  }

  String getTimeDescription() {
    if (sendTime == 0) return '未知时间';
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(sendTime * 1000);
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays <= 7) {
      return '${diff.inDays}天前';
    } else {
      final year = date.year == now.year ? '' : '${date.year}年';
      return '$year${date.month}月${date.day}日';
    }
  }

  UserNotice copyWith({
    String? id,
    String? title,
    String? content,
    String? rtfContent,
    int? isread,
    String? creater,
    String? createrName,
    int? sourceType,
    String? sourceName,
    int? createTime,
    int? sendTime,
    List<UserNoticeAttachment>? attachments,
  }) {
    return UserNotice(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      rtfContent: rtfContent ?? this.rtfContent,
      isread: isread ?? this.isread,
      creater: creater ?? this.creater,
      createrName: createrName ?? this.createrName,
      sourceType: sourceType ?? this.sourceType,
      sourceName: sourceName ?? this.sourceName,
      createTime: createTime ?? this.createTime,
      sendTime: sendTime ?? this.sendTime,
      attachments: attachments ?? this.attachments,
    );
  }
}

class UserNoticeAttachment {
  final String title;
  final String attachment;
  final String size;
  final int attachmentType;
  final String examOrWorkId;
  final String examOrWork;
  final String clazzId;
  final String courseId;
  final String url;

  const UserNoticeAttachment({
    required this.title,
    required this.attachment,
    required this.size,
    this.attachmentType = 0,
    this.examOrWorkId = '',
    this.examOrWork = '',
    this.clazzId = '',
    this.courseId = '',
    this.url = '',
  });

  bool get isHomework => examOrWork == 'work' && url.isNotEmpty;
  bool get isExam => examOrWork == 'exam' && url.isNotEmpty;

  factory UserNoticeAttachment.fromJson(Map<String, dynamic> json) {
    final attWeb = json['att_web'] as Map<String, dynamic>? ?? {};

    return UserNoticeAttachment(
      title: json['title']?.toString() ?? attWeb['title']?.toString() ?? '',
      attachment: json['attachment']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      attachmentType: json['attachmentType'] as int? ?? 0,
      examOrWorkId: attWeb['examOrWorkId']?.toString() ?? '',
      examOrWork: attWeb['examOrWork'] ?? '',
      clazzId: attWeb['clazzId']?.toString() ?? '',
      courseId: attWeb['courseId']?.toString() ?? '',
      url: attWeb['url'] ?? '',
    );
  }

  UserNoticeAttachment copyWith({
    String? title,
    String? attachment,
    String? size,
    int? attachmentType,
    String? examOrWorkId,
    String? examOrWork,
    String? clazzId,
    String? courseId,
    String? url,
  }) {
    return UserNoticeAttachment(
      title: title ?? this.title,
      attachment: attachment ?? this.attachment,
      size: size ?? this.size,
      attachmentType: attachmentType ?? this.attachmentType,
      examOrWorkId: examOrWorkId ?? this.examOrWorkId,
      examOrWork: examOrWork ?? this.examOrWork,
      clazzId: clazzId ?? this.clazzId,
      courseId: courseId ?? this.courseId,
      url: url ?? this.url,
    );
  }
}
