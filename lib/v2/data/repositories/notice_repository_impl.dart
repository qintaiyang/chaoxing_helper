import 'package:fpdart/fpdart.dart';
import '../../domain/entities/notice.dart';
import '../../domain/entities/user_notice.dart';
import '../../domain/repositories/notice_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/remote/chaoxing/cx_notice_api.dart';
import '../mappers/notice_mapper.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final CXNoticeApi _cxApi;

  NoticeRepositoryImpl(this._cxApi);

  @override
  Future<Either<Failure, List<Notice>>> getCourseNotices({
    required String courseId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final dtos = await _cxApi.getCourseNotices(
        courseId: courseId,
        page: page,
        pageSize: pageSize,
      );
      return Right(NoticeMapper.toEntityList(dtos, courseId: courseId));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, List<UserNotice>>> getUserNotices({
    required String puid,
  }) async {
    try {
      final rawList = await _cxApi.syncUserNotices(puid: puid);
      return Right(rawList.map((e) => UserNotice.fromJson(e)).toList());
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getNoticeDetail({
    required String noticeId,
    String idCode = '',
  }) async {
    try {
      final result = await _cxApi.getNoticeDetail(
        noticeId: noticeId,
        idCode: idCode,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取通知详情失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, bool>> readNotice({required String noticeId}) async {
    try {
      final result = await _cxApi.readNotice(noticeId: noticeId);
      return Right(result);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getNoticeFolders({
    required String courseId,
  }) async {
    try {
      final result = await _cxApi.getNoticeFolders(courseId: courseId);
      return Right(result);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }
}
