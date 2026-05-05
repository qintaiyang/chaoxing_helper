import 'package:fpdart/fpdart.dart';
import '../../domain/entities/group_chat.dart';
import '../../domain/repositories/group_chat_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/remote/chaoxing/cx_group_im_api.dart';
import '../mappers/group_chat_mapper.dart';

class GroupChatRepositoryImpl implements GroupChatRepository {
  final CXGroupImApi _cxApi;

  GroupChatRepositoryImpl(this._cxApi);

  @override
  Future<Either<Failure, List<GroupChat>>> getChatList({
    required String tuid,
    required String puid,
    required String token,
  }) async {
    try {
      final dtos = await _cxApi.getChatList(
        tuid: tuid,
        puid: puid,
        token: token,
      );
      return Right(GroupChatMapper.toEntityList(dtos));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, List<GroupMessage>>> getHistoryMessages({
    required String tuid,
    required String puid,
    required String token,
    required String chatId,
    int limit = 20,
  }) async {
    try {
      final dtos = await _cxApi.getHistoryMessages(
        tuid: tuid,
        puid: puid,
        token: token,
        chatId: chatId,
        limit: limit,
      );
      return Right(GroupMessageMapper.toEntityList(dtos));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, bool>> addMessage({
    required String tuid,
    required String puid,
    required String token,
    required String chatId,
    required String content,
  }) async {
    try {
      final result = await _cxApi.addMessage(
        tuid: tuid,
        puid: puid,
        token: token,
        chatId: chatId,
        content: content,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, List<GroupMember>>> getGroupInfoByCount({
    required String roomId,
    required String token,
    required String tuid,
  }) async {
    try {
      final dtos = await _cxApi.getGroupInfoByCount(
        roomId: roomId,
        token: token,
        tuid: tuid,
      );
      return Right(GroupMemberMapper.toEntityList(dtos));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, List<GroupMember>>> getUserInfoByTuid2({
    required List<String> tuids,
    required String chatId,
  }) async {
    try {
      final dtos = await _cxApi.getUserInfoByTuid2(
        tuids: tuids,
        chatId: chatId,
      );
      return Right(GroupMemberMapper.toEntityList(dtos));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, String>> getImToken() async {
    try {
      final result = await _cxApi.getImToken();
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取IM Token失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }
}
