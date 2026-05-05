class Quiz {
  final String quizId;
  final String courseId;
  final String classId;
  final String title;
  final String description;
  final int type;
  final int startTime;
  final int endTime;
  final bool isAnswer;
  final int questionCount;

  const Quiz({
    required this.quizId,
    required this.courseId,
    required this.classId,
    required this.title,
    this.description = '',
    this.type = 0,
    this.startTime = 0,
    this.endTime = 0,
    this.isAnswer = false,
    this.questionCount = 0,
  });

  Quiz copyWith({
    String? quizId,
    String? courseId,
    String? classId,
    String? title,
    String? description,
    int? type,
    int? startTime,
    int? endTime,
    bool? isAnswer,
    int? questionCount,
  }) {
    return Quiz(
      quizId: quizId ?? this.quizId,
      courseId: courseId ?? this.courseId,
      classId: classId ?? this.classId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAnswer: isAnswer ?? this.isAnswer,
      questionCount: questionCount ?? this.questionCount,
    );
  }
}
