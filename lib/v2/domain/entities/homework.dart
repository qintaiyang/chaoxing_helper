class HomeworkInfo {
  final String workId;
  final String courseId;
  final String classId;
  final String cpi;
  final String title;
  final String status;
  final String enc;
  final String answerId;
  final String taskUrl;

  const HomeworkInfo({
    required this.workId,
    required this.courseId,
    required this.classId,
    required this.cpi,
    required this.title,
    required this.status,
    required this.enc,
    required this.answerId,
    required this.taskUrl,
  });

  HomeworkInfo copyWith({
    String? workId,
    String? courseId,
    String? classId,
    String? cpi,
    String? title,
    String? status,
    String? enc,
    String? answerId,
    String? taskUrl,
  }) {
    return HomeworkInfo(
      workId: workId ?? this.workId,
      courseId: courseId ?? this.courseId,
      classId: classId ?? this.classId,
      cpi: cpi ?? this.cpi,
      title: title ?? this.title,
      status: status ?? this.status,
      enc: enc ?? this.enc,
      answerId: answerId ?? this.answerId,
      taskUrl: taskUrl ?? this.taskUrl,
    );
  }
}
