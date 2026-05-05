import 'package:fpdart/fpdart.dart';
import '../entities/notice.dart';
import '../repositories/notice_repository.dart';
import '../failures/failure.dart';

class GetCourseNoticesUseCase {
  final NoticeRepository _noticeRepo;

  GetCourseNoticesUseCase(this._noticeRepo);

  Future<Either<Failure, List<Notice>>> execute({
    required String courseId,
    int page = 1,
    int pageSize = 20,
  }) {
    return _noticeRepo.getCourseNotices(
      courseId: courseId,
      page: page,
      pageSize: pageSize,
    );
  }
}
