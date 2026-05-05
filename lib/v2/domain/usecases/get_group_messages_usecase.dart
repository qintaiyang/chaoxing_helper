import 'package:fpdart/fpdart.dart';
import '../entities/group_chat.dart';
import '../repositories/group_chat_repository.dart';
import '../failures/failure.dart';

class GetGroupMessagesUseCase {
  final GroupChatRepository _groupChatRepo;

  GetGroupMessagesUseCase(this._groupChatRepo);

  Future<Either<Failure, List<GroupMessage>>> execute({
    required String tuid,
    required String puid,
    required String token,
    required String chatId,
    int limit = 20,
  }) {
    return _groupChatRepo.getHistoryMessages(
      tuid: tuid,
      puid: puid,
      token: token,
      chatId: chatId,
      limit: limit,
    );
  }
}
