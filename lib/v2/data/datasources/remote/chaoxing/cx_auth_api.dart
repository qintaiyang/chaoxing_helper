import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../../infra/crypto/encryption_service.dart';
import '../../../../infra/crypto/crypto_config.dart';
import '../../../../infra/storage/cookie_manager.dart';
import '../../../models/user_dto.dart';

class CXAuthApi {
  final AppDioClient _client;
  final EncryptionService _encryption;

  CXAuthApi(this._client, this._encryption, CookieManager _);

  CookieInterceptor get _interceptor =>
      _client.dio.interceptors.whereType<CookieInterceptor>().first;

  void setLoggingInFlag(bool value) {
    _interceptor.isLoggingIn.value = value;
  }

  Future<Map<String, dynamic>?> loginWeb(
    String username,
    String password, {
    String fid = '-1',
    String refer = '',
  }) async {
    try {
      debugPrint('🌐 V2 Web登录 - Step 1: 访问登录页获取session cookie...');
      const loginPageUrl = 'https://passport2.chaoxing.com/login';
      _interceptor.isLoggingIn.value = true;
      await _client.sendRequest(loginPageUrl, responseType: ResponseType.plain);
      await Future.delayed(const Duration(milliseconds: 300));

      debugPrint('🌐 V2 Web登录 - Step 2: 提交登录表单...');
      const url = 'https://passport2.chaoxing.com/fanyalogin';
      final usernameCipher = _encryption.aesCbcEncrypt(
        username,
        CryptoConfig.production.webLoginKey,
      );
      final passwordCipher = _encryption.aesCbcEncrypt(
        password,
        CryptoConfig.production.webLoginKey,
      );

      final formData = {
        'fid': fid,
        'uname': usernameCipher,
        'password': passwordCipher,
        'refer': refer,
        't': 'true',
        'forbidotherlogin': '0',
        'validate': '',
        'doubleFactorLogin': '0',
        'independentId': '0',
        'independentNameId': '0',
      };

      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
      );
      debugPrint('🌐 V2 Web登录 - 响应: ${response.data}');

      if (response.data != null && response.data['status'] == true) {
        debugPrint('✅ V2 Web登录成功');
        await Future.delayed(const Duration(milliseconds: 300));
      } else {
        debugPrint('❌ V2 Web登录失败: ${response.data}');
      }

      return response.data;
    } catch (e) {
      debugPrint('❌ V2 Web登录异常: $e');
      return null;
    } finally {
      _interceptor.isLoggingIn.value = false;
    }
  }

  Future<UserDto?> getUserInfo() async {
    try {
      const url = 'https://sso.chaoxing.com/apis/login/userLogin4Uname.do';
      final response = await _client.sendRequest(url);

      final data = response.data;
      if (data is Map<String, dynamic> && data['result'] == 1) {
        final msg = data['msg'] as Map<String, dynamic>;
        final accountInfo = msg['accountInfo'] as Map<String, dynamic>?;

        ImAccountDto? imAccountDto;
        if (accountInfo != null) {
          final imAccount = accountInfo['imAccount'] as Map<String, dynamic>?;
          if (imAccount != null) {
            final userName = imAccount['username'] as String?;
            final passwordCipher = imAccount['password'] as String?;
            if (userName != null && passwordCipher != null) {
              final password = _encryption.desEcbDecrypt(
                passwordCipher,
                CryptoConfig.production.imKey,
              );
              imAccountDto = ImAccountDto(
                userName: userName,
                password: password,
              );
            }
          }
        }

        return UserDto(
          uid: msg['puid']?.toString() ?? '',
          name: msg['name'] ?? '未知用户',
          avatar: msg['pic'] ?? '',
          phone: msg['phone'] ?? '',
          school: msg['schoolname'] ?? '',
          platform: 'chaoxing',
          imAccount: imAccountDto,
          status: true,
        );
      }
      return null;
    } catch (e) {
      debugPrint('获取用户信息异常: $e');
      return null;
    }
  }

  Future<bool> sendCaptcha(String phone) async {
    try {
      const url = 'https://passport2-api.chaoxing.com/api/sendcaptcha';

      final timestampMS = DateTime.now().millisecondsSinceEpoch.toString();
      final enc = _encryption.md5Hash(
        phone + CryptoConfig.production.sendCaptchaKey + timestampMS,
      );

      final formData = {
        'to': phone,
        'countrycode': '86',
        'time': timestampMS,
        'enc': enc,
      };

      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
      );
      return response.data?['status'] == true;
    } catch (e) {
      debugPrint('发送验证码异常: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginWithPhone(
    String phone,
    String code,
  ) async {
    try {
      const url = 'https://passport2.chaoxing.com/fanyaloginphone';
      _interceptor.isLoggingIn.value = true;
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: {'phone': phone, 'code': code},
      );
      return response.data;
    } catch (e) {
      debugPrint('手机登录异常: $e');
      return null;
    } finally {
      _interceptor.isLoggingIn.value = false;
    }
  }

  Future<Map<String, dynamic>?> loginAPP(
    String username,
    String password, {
    String loginType = '1',
  }) async {
    try {
      const url =
          'https://passport2-api.chaoxing.com/v11/loginregister?cx_xxt_passport=json';

      final loginData = {'uname': username, 'code': password};
      final loginInfo = _encryption.aesEcbEncrypt(
        json.encode(loginData),
        CryptoConfig.production.appLoginKey,
      );

      final formData = {
        'logininfo': loginInfo,
        'loginType': loginType,
        'roleSelect': 'true',
        'entype': '1',
      };
      if (loginType == '2') {
        formData['countrycode'] = '86';
      }

      _interceptor.isLoggingIn.value = true;
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
      );
      return response.data;
    } catch (e) {
      debugPrint('APP登录异常: $e');
      return null;
    } finally {
      _interceptor.isLoggingIn.value = false;
    }
  }

  Future<Map<String, dynamic>?> checkQRAuthStatus(
    String uuid,
    String enc,
  ) async {
    try {
      const url = 'https://passport2.chaoxing.com/getauthstatus/v2';
      final formData = {
        'enc': enc,
        'uuid': uuid,
        'doubleFactorLogin': '0',
        'forbidotherlogin': '0',
      };

      _interceptor.isLoggingIn.value = true;
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
      );
      return response.data;
    } catch (e) {
      debugPrint('二维码状态检查异常: $e');
      return null;
    } finally {
      _interceptor.isLoggingIn.value = false;
    }
  }

  /// 授权网页端 QR 登录 (APP扫码后调用此接口完成授权)
  /// 逆向依据: chaoxing.har (官方学习通APP RealReqable抓包)
  /// 注意：此流程不使用 isLoggingIn，需要利用当前已登录用户的 Cookie 来完成授权
  Future<Map<String, dynamic>?> authorizeWebQR(String uuid, String enc) async {
    try {
      debugPrint('🌐 V2 网页QR授权 - Step 1: 访问passport登录页刷新session...');
      const loginPageUrl = 'https://passport2.chaoxing.com/login';
      await _client.sendRequest(loginPageUrl, responseType: ResponseType.plain);
      await Future.delayed(const Duration(milliseconds: 200));

      debugPrint('🌐 V2 网页QR授权 - Step 2: GET toauthlogin...');
      await _client.sendRequest(
        'https://passport2.chaoxing.com/toauthlogin',
        method: 'GET',
        params: {
          'uuid': uuid,
          'enc': enc,
          'xxtrefer': '',
          'clientid': '',
          'type': '1',
          'mobiletip': '电脑端登录确认',
        },
        responseType: ResponseType.plain,
      );
      await Future.delayed(const Duration(milliseconds: 200));

      debugPrint('🌐 V2 网页QR授权 - Step 3: POST authlogin 确认授权...');
      final response = await _client.sendRequest(
        'https://passport2.chaoxing.com/authlogin',
        method: 'POST',
        body: 'enc=$enc&uuid=$uuid',
        contentType: 'application/x-www-form-urlencoded',
        responseType: ResponseType.json,
      );
      debugPrint('🌐 V2 authlogin响应: ${response.data}');

      if (response.data != null && response.data['status'] == true) {
        debugPrint('✅ V2 网页QR授权成功');
        await Future.delayed(const Duration(milliseconds: 300));
        return {'status': true, 'mes': '验证通过'};
      }

      debugPrint('❌ V2 网页QR授权失败: ${response.data}');
      return {'status': false, 'mes': '授权失败', 'type': '3'};
    } catch (e) {
      debugPrint('authorizeWebQR error: $e');
      return null;
    }
  }
}
