import 'package:fpdart/fpdart.dart';
import '../entities/notice.dart';
import '../entities/user_notice.dart';
import '../failures/failure.dart';

abstract class NoticeRepository {
  Future<Either<Failure, List<Notice>>> getCourseNotices({
    required String courseId,
    int page,
    int pageSize,
  });
  Future<Either<Failure, List<UserNotice>>> getUserNotices({
    required String puid,
  });
  Future<Either<Failure, Map<String, dynamic>>> getNoticeDetail({
    required String noticeId,
    String idCode,
  });
  Future<Either<Failure, bool>> readNotice({required String noticeId});
  Future<Either<Failure, List<Map<String, dynamic>>>> getNoticeFolders({
    required String courseId,
  });
}
