import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../../infra/crypto/encryption_service.dart';

class CXAccountManageApi {
  final AppDioClient _client;
  final EncryptionService _encryption;

  static const _baseUrl = 'https://passport2.chaoxing.com';
  static const _aesKey = '1f05vuQd0mK6Vph6saHqp9k7';
  static const _browserUa =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36';

  CXAccountManageApi(this._client, this._encryption);

  Future<Uint8List?> downloadCaptchaImage() async {
    try {
      final response = await _client.sendRequest(
        '$_baseUrl/num/code',
        params: {'t': DateTime.now().millisecondsSinceEpoch.toString()},
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'User-Agent': _browserUa},
        ),
      );
      if (response.data is Uint8List) {
        return response.data as Uint8List;
      }
      return null;
    } catch (e) {
      debugPrint('downloadCaptchaImage error: $e');
      return null;
    }
  }

  Future<({bool success, String message})> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    required String captcha,
  }) async {
    try {
      final response = await _client.sendRequest(
        'https://i.chaoxing.com/settings/resetpassword',
        method: 'POST',
        body: {
          'passwd': _encryption.aesEcbEncrypt(oldPassword, _aesKey),
          'npasswd': _encryption.aesEcbEncrypt(newPassword, _aesKey),
          'npasswd1': _encryption.aesEcbEncrypt(confirmPassword, _aesKey),
          'recode': captcha,
        },
        options: Options(
          headers: {
            'User-Agent': _browserUa,
            'Accept': 'application/json, text/javascript, */*; q=0.01',
            'Referer': 'https://i.chaoxing.com/base/settings?t=',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        contentType: 'application/x-www-form-urlencoded',
      );

      final data = response.data;
      if (data is Map) {
        final msg = data['msg']?.toString() ?? '';
        return (
          success: msg.contains('成功') || msg.contains('修改成功'),
          message: msg,
        );
      }
      return (success: false, message: '修改失败');
    } catch (e) {
      debugPrint('changePassword error: $e');
      return (success: false, message: '修改失败: $e');
    }
  }
}
