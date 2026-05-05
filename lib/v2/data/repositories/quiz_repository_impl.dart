import 'package:fpdart/fpdart.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/remote/chaoxing/cx_quiz_api.dart';

class QuizRepositoryImpl implements QuizRepository {
  final CXQuizApi _cxApi;

  QuizRepositoryImpl(this._cxApi);

  @override
  Future<Either<Failure, bool>> checkQuizStatus({
    required String classId,
    required String activeId,
  }) async {
    try {
      final result = await _cxApi.checkStatus(
        classId: classId,
        activeId: activeId,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '检查练习状态失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitQuizAnswer({
    required String classId,
    required String courseId,
    required String activeId,
    required String answer,
  }) async {
    try {
      final result = await _cxApi.submitAnswer(
        classId: classId,
        courseId: courseId,
        activeId: activeId,
        answer: answer,
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
  Future<Either<Failure, Map<String, dynamic>>> getQuizDetail({
    required String activeId,
    bool v2 = false,
  }) async {
    try {
      final result = await _cxApi.getQuizDetail(activeId: activeId, v2: v2);
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取练习详情失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitVote({
    required String courseId,
    required String classId,
    required String activeId,
    required String questionId,
    required String answer,
  }) async {
    try {
      final result = await _cxApi.submitVote(
        courseId: courseId,
        classId: classId,
        activeId: activeId,
        questionId: questionId,
        answer: answer,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '提交投票失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitQuestionnaire({
    required String courseId,
    required String classId,
    required String activeId,
    required Map<String, List<String>> answers,
  }) async {
    try {
      final result = await _cxApi.submitQuestionnaire(
        courseId: courseId,
        classId: classId,
        activeId: activeId,
        answers: answers,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '提交问卷失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }
}
