class Notice {
  final String noticeId;
  final String courseId;
  final String title;
  final String content;
  final String author;
  final int createTime;
  final bool isRead;
  final String folderId;

  const Notice({
    required this.noticeId,
    required this.courseId,
    required this.title,
    this.content = '',
    this.author = '',
    this.createTime = 0,
    this.isRead = false,
    this.folderId = '',
  });

  Notice copyWith({
    String? noticeId,
    String? courseId,
    String? title,
    String? content,
    String? author,
    int? createTime,
    bool? isRead,
    String? folderId,
  }) {
    return Notice(
      noticeId: noticeId ?? this.noticeId,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      createTime: createTime ?? this.createTime,
      isRead: isRead ?? this.isRead,
      folderId: folderId ?? this.folderId,
    );
  }
}
