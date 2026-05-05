import '../../domain/entities/exam.dart';
import '../models/exam_dto.dart';

class ExamMapper {
  static Exam toEntity(ExamDto dto, {String courseId = '', String classId = ''}) {
    final status = dto.status.toLowerCase();
    final isCompleted = status.contains('已完成') || 
                        status.contains('已提交') || 
                        status.contains('已批') ||
                        status.contains('已查') ||
                        dto.extras['isSubmit'] == 1 ||
                        dto.extras['isSubmit'] == '1';
    final isStarted = isCompleted || 
                      status.contains('进行中') || 
                      status.contains('已开始') ||
                      dto.extras['isStart'] == 1 ||
                      dto.extras['isStart'] == '1';

    return Exam(
      examId: dto.examId,
      courseId: dto.extras['courseId']?.toString() ?? courseId,
      classId: dto.extras['classId']?.toString() ?? classId,
      title: dto.title,
      description: dto.description,
      startTime: dto.startTime,
      endTime: dto.endTime,
      duration: dto.duration,
      status: dto.status,
      totalScore: dto.totalScore,
      passScore: dto.passScore,
      questionCount: dto.questionCount,
      isStarted: isStarted,
      isCompleted: isCompleted,
      score: dto.extras['score'] != null ? int.tryParse(dto.extras['score'].toString()) : null,
    );
  }

  static List<Exam> toEntityList(List<ExamDto> dtos, {String courseId = '', String classId = ''}) {
    return dtos.map((dto) => toEntity(dto, courseId: courseId, classId: classId)).toList();
  }
}
