import 'package:fpdart/fpdart.dart';
import '../entities/group_chat.dart';
import '../failures/failure.dart';

abstract class GroupChatRepository {
  Future<Either<Failure, List<GroupChat>>> getChatList({
    required String tuid,
    required String puid,
    required String token,
  });
  Future<Either<Failure, List<GroupMessage>>> getHistoryMessages({
    required String tuid,
    required String puid,
    required String token,
    required String chatId,
    int limit,
  });
  Future<Either<Failure, bool>> addMessage({
    required String tuid,
    required String puid,
    required String token,
    required String chatId,
    required String content,
  });
  Future<Either<Failure, List<GroupMember>>> getGroupInfoByCount({
    required String roomId,
    required String token,
    required String tuid,
  });
  Future<Either<Failure, List<GroupMember>>> getUserInfoByTuid2({
    required List<String> tuids,
    required String chatId,
  });
  Future<Either<Failure, String>> getImToken();
}
