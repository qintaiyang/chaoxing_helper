import 'package:fpdart/fpdart.dart';
import '../entities/group_chat.dart';
import '../repositories/group_chat_repository.dart';
import '../failures/failure.dart';

class GetGroupChatListUseCase {
  final GroupChatRepository _groupChatRepo;

  GetGroupChatListUseCase(this._groupChatRepo);

  Future<Either<Failure, List<GroupChat>>> execute({
    required String tuid,
    required String puid,
    required String token,
  }) {
    return _groupChatRepo.getChatList(tuid: tuid, puid: puid, token: token);
  }
}
