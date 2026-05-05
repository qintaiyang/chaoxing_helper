import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user_notice.dart';
import '../../domain/repositories/notice_repository.dart';
import '../../domain/failures/failure.dart';

class GetUserNoticesUseCase {
  final NoticeRepository _repository;

  GetUserNoticesUseCase(this._repository);

  Future<Either<Failure, List<UserNotice>>> call({required String puid}) {
    return _repository.getUserNotices(puid: puid);
  }
}
