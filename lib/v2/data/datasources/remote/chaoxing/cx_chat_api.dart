import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';

class CXChatApi {
  final AppDioClient _client;

  CXChatApi(this._client);

  static const _baseUrl = 'https://mobilelearn.chaoxing.com';

  Future<Map<String, dynamic>> sendLocationMessage({
    required String sendId,
    required String receiveId,
    required String chatName,
    required String chatIco,
    required String latitude,
    required String longitude,
    required String address,
    required String name,
  }) async {
    try {
      const url = '$_baseUrl/mobilelearn/chaoxing/chat/sendMsg';
      final extData = {
        'location': {
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
          'name': name,
        },
      };

      final response = await _client.sendRequest(
        url,
        method: 'POST',
        params: {
          'ext': extData.toString(),
          'chatIco': chatIco,
          'chatName': chatName,
          'content': '[位置]',
          'msgType': '1',
          'receiveId': receiveId,
          'sendId': sendId,
        },
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
      );

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'result': false, 'msg': '响应格式错误'};
    } catch (e) {
      debugPrint('发送位置消息失败: $e');
      return {'result': false, 'msg': '发送失败: $e'};
    }
  }
}
