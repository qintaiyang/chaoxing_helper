class Todo {
  final String todoId;
  final String title;
  final String content;
  final String courseId;
  final String endTime;
  final int remind;
  final int remindType;
  final bool isCompleted;
  final int createTime;

  const Todo({
    required this.todoId,
    required this.title,
    this.content = '',
    this.courseId = '',
    this.endTime = '',
    this.remind = 0,
    this.remindType = 0,
    this.isCompleted = false,
    this.createTime = 0,
  });

  Todo copyWith({
    String? todoId,
    String? title,
    String? content,
    String? courseId,
    String? endTime,
    int? remind,
    int? remindType,
    bool? isCompleted,
    int? createTime,
  }) {
    return Todo(
      todoId: todoId ?? this.todoId,
      title: title ?? this.title,
      content: content ?? this.content,
      courseId: courseId ?? this.courseId,
      endTime: endTime ?? this.endTime,
      remind: remind ?? this.remind,
      remindType: remindType ?? this.remindType,
      isCompleted: isCompleted ?? this.isCompleted,
      createTime: createTime ?? this.createTime,
    );
  }
}
