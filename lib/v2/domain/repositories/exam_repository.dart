import 'package:fpdart/fpdart.dart';
import '../entities/exam.dart';
import '../failures/failure.dart';

abstract class ExamRepository {
  Future<Either<Failure, List<Exam>>> getExamList({
    required String courseId,
    required String classId,
    int page,
    int pageSize,
  });
  Future<Either<Failure, Map<String, dynamic>>> getExamDetail({
    required String examId,
    required String courseId,
    required String classId,
  });
  Future<Either<Failure, Map<String, dynamic>>> getExamPaper({
    required String examId,
    required String courseId,
    required String classId,
  });
  Future<Either<Failure, Map<String, dynamic>>> submitExamAnswer({
    required String examId,
    required String courseId,
    required String classId,
    required String answers,
    required int duration,
  });
  Future<Either<Failure, Map<String, dynamic>>> startExam({
    required String examId,
    required String courseId,
    required String classId,
  });
  Future<Either<Failure, Map<String, dynamic>>> getExamResult({
    required String examId,
    required String courseId,
    required String classId,
  });
}
