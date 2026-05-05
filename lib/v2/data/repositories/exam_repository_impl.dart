import 'package:fpdart/fpdart.dart';
import '../../domain/entities/exam.dart';
import '../../domain/repositories/exam_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/remote/chaoxing/cx_exam_api.dart';
import '../mappers/exam_mapper.dart';

class ExamRepositoryImpl implements ExamRepository {
  final CXExamApi _cxApi;

  ExamRepositoryImpl(this._cxApi);

  @override
  Future<Either<Failure, List<Exam>>> getExamList({
    required String courseId,
    required String classId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final dtos = await _cxApi.getExamList(
        courseId: courseId,
        classId: classId,
        page: page,
        pageSize: pageSize,
      );
      return Right(
        ExamMapper.toEntityList(dtos, courseId: courseId, classId: classId),
      );
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getExamDetail({
    required String examId,
    required String courseId,
    required String classId,
  }) async {
    try {
      final result = await _cxApi.getExamDetail(
        examId: examId,
        courseId: courseId,
        classId: classId,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取考试详情失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getExamPaper({
    required String examId,
    required String courseId,
    required String classId,
  }) async {
    try {
      final result = await _cxApi.getExamPaper(
        examId: examId,
        courseId: courseId,
        classId: classId,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取试卷失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitExamAnswer({
    required String examId,
    required String courseId,
    required String classId,
    required String answers,
    required int duration,
  }) async {
    try {
      final result = await _cxApi.submitExamAnswer(
        examId: examId,
        courseId: courseId,
        classId: classId,
        answers: answers,
        duration: duration,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '提交答案失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> startExam({
    required String examId,
    required String courseId,
    required String classId,
  }) async {
    try {
      final result = await _cxApi.startExam(
        examId: examId,
        courseId: courseId,
        classId: classId,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '开始考试失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getExamResult({
    required String examId,
    required String courseId,
    required String classId,
  }) async {
    try {
      final result = await _cxApi.getExamResult(
        examId: examId,
        courseId: courseId,
        classId: classId,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取成绩失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }
}
