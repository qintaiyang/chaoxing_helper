class Exam {
  final String examId;
  final String courseId;
  final String classId;
  final String title;
  final String description;
  final int startTime;
  final int endTime;
  final int duration;
  final String status;
  final int totalScore;
  final int passScore;
  final int questionCount;
  final bool isStarted;
  final bool isCompleted;
  final int? score;

  const Exam({
    required this.examId,
    required this.courseId,
    required this.classId,
    required this.title,
    this.description = '',
    this.startTime = 0,
    this.endTime = 0,
    this.duration = 0,
    this.status = '',
    this.totalScore = 0,
    this.passScore = 0,
    this.questionCount = 0,
    this.isStarted = false,
    this.isCompleted = false,
    this.score,
  });

  Exam copyWith({
    String? examId,
    String? courseId,
    String? classId,
    String? title,
    String? description,
    int? startTime,
    int? endTime,
    int? duration,
    String? status,
    int? totalScore,
    int? passScore,
    int? questionCount,
    bool? isStarted,
    bool? isCompleted,
    int? score,
  }) {
    return Exam(
      examId: examId ?? this.examId,
      courseId: courseId ?? this.courseId,
      classId: classId ?? this.classId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      totalScore: totalScore ?? this.totalScore,
      passScore: passScore ?? this.passScore,
      questionCount: questionCount ?? this.questionCount,
      isStarted: isStarted ?? this.isStarted,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
    );
  }
}
