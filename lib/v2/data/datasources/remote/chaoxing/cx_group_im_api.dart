import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../models/group_chat_dto.dart';

class CXGroupImApi {
  final AppDioClient _client;

  CXGroupImApi(this._client);

  static const _baseUrl = 'https://im.chaoxing.com';

  Future<List<GroupChatDto>> getChatList({
    required String tuid,
    required String puid,
    required String token,
  }) async {
    try {
      const url = '$_baseUrl/webim/message/list/getMessageList';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        params: {'tuid': tuid, 'puid': puid, 'token': token},
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
      );

      if (response.data['status'] == 'success') {
        final data = response.data['data'] as List;
        return data
            .whereType<Map<String, dynamic>>()
            .map((item) => GroupChatDto.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('获取聊天列表失败: $e');
    }
    return [];
  }

  Future<List<GroupMessageDto>> getHistoryMessages({
    required String tuid,
    required String puid,
    required String token,
    required String chatId,
    int limit = 20,
  }) async {
    try {
      const url = '$_baseUrl/webim/message/history/getHistoryByMsgId';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        params: {
          'tuid': tuid,
          'puid': puid,
          'token': token,
          'chatId': chatId,
          'limit': limit.toString(),
        },
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
      );

      if (response.data['status'] == 'success') {
        final data = response.data['data'] as List? ?? [];
        return data
            .whereType<Map<String, dynamic>>()
            .map((item) => GroupMessageDto.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('获取历史消息失败: $e');
    }
    return [];
  }

  Future<bool> addMessage({
    required String tuid,
    required String puid,
    required String token,
    required String chatId,
    required String content,
  }) async {
    try {
      const url = '$_baseUrl/webim/message/history/addMessage';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        params: {
          'tuid': tuid,
          'puid': puid,
          'token': token,
          'chatId': chatId,
          'content': content,
        },
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
      );
      return response.data['status'] == 'success';
    } catch (e) {
      debugPrint('发送消息失败: $e');
      return false;
    }
  }

  Future<bool> addChatList({
    required String tuid,
    required String puid,
    required String token,
    required String chatId,
    required String chatName,
    required String chatIco,
    required bool isGroup,
    required int count,
  }) async {
    try {
      const url = '$_baseUrl/webim/message/list/addList';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        params: {
          'tuid': tuid,
          'puid': puid,
          'token': token,
          'chatId': chatId,
          'chatName': chatName,
          'chatIco': chatIco,
          'isGroup': isGroup ? '1' : '0',
          'subFolder': '0',
          'level': '0',
          'count': count.toString(),
        },
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
      );
      return response.data['status'] == 'success';
    } catch (e) {
      debugPrint('添加聊天列表失败: $e');
      return false;
    }
  }

  Future<List<GroupMemberDto>> getGroupInfoByCount({
    required String roomId,
    required String token,
    required String tuid,
  }) async {
    try {
      const url = '$_baseUrl/webim/group/getGroupInfoByCount';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        params: {'roomId': roomId, 'token': token, 'tuid': tuid},
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
      );

      if (response.data['status'] == 'success') {
        final members = response.data['members'] as List? ?? [];
        return members
            .whereType<Map<String, dynamic>>()
            .map((item) => GroupMemberDto.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('获取群组成员信息失败: $e');
    }
    return [];
  }

  Future<GroupMemberDto?> getUserInfoByTuid({
    required String tuid,
    required String puid,
    required String token,
  }) async {
    try {
      const url = '$_baseUrl/webim/user/getUserInfoByTuid';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        params: {'tuid': tuid, 'puid': puid, 'token': token},
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
      );

      if (response.data != null) {
        final data = response.data is Map
            ? response.data as Map<String, dynamic>
            : null;
        if (data != null) {
          if (data['status'] == 'success' && data['data'] != null) {
            return GroupMemberDto.fromJson(data['data']);
          }
          if (data.containsKey('tuid') || data.containsKey('pic')) {
            return GroupMemberDto.fromJson(data);
          }
        }
      }
    } catch (e) {
      debugPrint('获取用户信息失败: $e');
    }
    return null;
  }

  Future<List<GroupMemberDto>> getUserInfoByTuid2({
    required List<String> tuids,
    required String chatId,
  }) async {
    try {
      const url = '$_baseUrl/webim/user/getUserInfoByTuid2';
      final response = await _client.sendRequest(
        url,
        params: {'tuid': tuids.join(','), 'chatId': chatId},
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Accept-Charset': 'utf-8',
          'Accept': 'application/json; charset=utf-8',
        },
      );

      if (response.data != null) {
        final data = response.data is Map
            ? response.data as Map<String, dynamic>
            : null;
        if (data != null && (data['result'] == 1 || data['result'] == true)) {
          final dataList = data['data'] is List ? data['data'] as List : [];
          return dataList
              .whereType<Map<String, dynamic>>()
              .map((item) => GroupMemberDto.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('批量获取用户信息失败: $e');
    }
    return [];
  }

  Future<String?> getImToken() async {
    try {
      const url = 'https://im.chaoxing.com/webim/me';
      final response = await _client.sendRequest(
        url,
        responseType: ResponseType.plain,
      );

      if (response.data is String) {
        final html = response.data as String;
        debugPrint('getImToken HTML长度: ${html.length}');
        if (html.length < 500) {
          debugPrint('getImToken HTML: $html');
        }
        final tokenMatch = RegExp(
          r'<span id="myToken"[^>]*>([^<]+)</span>',
        ).firstMatch(html);
        if (tokenMatch != null) {
          final token = tokenMatch.group(1)!;
          debugPrint('✅ getImToken 成功: ${token.substring(0, 20)}...');
          return token;
        }
        debugPrint('⚠️ getImToken 未找到 myToken span');
      } else {
        debugPrint('⚠️ getImToken 响应不是字符串: ${response.data.runtimeType}');
      }
    } catch (e) {
      debugPrint('获取IM Token失败: $e');
    }
    return null;
  }
}
