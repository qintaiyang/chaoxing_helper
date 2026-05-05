import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../models/signin_dto.dart';

class CXSignInApi {
  final AppDioClient _client;

  CXSignInApi(this._client);

  Future<SignInDto?> normalSignIn({
    required String courseId,
    required String activeId,
    required String uid,
    required String name,
    String? objectId,
    String? validate,
  }) async {
    try {
      const url = 'https://mobilelearn.chaoxing.com/pptSign/stuSignajax';
      final params = <String, String>{
        'activeId': activeId,
        'courseId': courseId,
        'uid': uid,
        'clientip': '',
        'latitude': '-1',
        'longitude': '-1',
        'appType': '15',
        'fid': '0',
        'name': name,
        'deviceCode': _getDeviceCode(),
      };
      if (objectId != null) params['objectId'] = objectId;
      if (validate != null) params['validate'] = validate;

      final response = await _client.sendRequest(
        url,
        params: params,
        responseType: ResponseType.plain,
      );
      return SignInDto(result: response.data?.toString() ?? '');
    } catch (e) {
      debugPrint('normalSignIn error: $e');
      return null;
    }
  }

  Future<bool?> checkSignCode({
    required String activeId,
    required String signCode,
  }) async {
    try {
      const url =
          'https://mobilelearn.chaoxing.com/widget/sign/pcStuSignController/checkSignCode';
      final response = await _client.sendRequest(
        url,
        params: {'activeId': activeId, 'signCode': signCode},
      );
      return response.data['result'] == 1;
    } catch (e) {
      debugPrint('checkSignCode error: $e');
      return null;
    }
  }

  Future<SignInDto?> codeSignIn({
    required String courseId,
    required String activeId,
    required String signCode,
    required String uid,
    required String name,
    String? validate,
  }) async {
    try {
      const url = 'https://mobilelearn.chaoxing.com/pptSign/stuSignajax';
      final params = <String, String>{
        'activeId': activeId,
        'courseId': courseId,
        'uid': uid,
        'clientip': '',
        'latitude': '-1',
        'longitude': '-1',
        'appType': '15',
        'fid': '0',
        'name': name,
        'signCode': signCode,
        'deviceCode': _getDeviceCode(),
      };
      if (validate != null) params['validate'] = validate;

      final response = await _client.sendRequest(
        url,
        params: params,
        responseType: ResponseType.plain,
      );
      return SignInDto(result: response.data?.toString() ?? '');
    } catch (e) {
      debugPrint('codeSignIn error: $e');
      return null;
    }
  }

  Future<SignInDto?> locationSignIn({
    required String courseId,
    required String activeId,
    required String address,
    required double latitude,
    required double longitude,
    required String uid,
    required String name,
    String? validate,
    String? faceId,
  }) async {
    try {
      const url = 'https://mobilelearn.chaoxing.com/pptSign/stuSignajax';
      final params = <String, String>{
        'name': name,
        'address': address,
        'activeId': activeId,
        'courseId': courseId,
        'uid': uid,
        'clientip': '',
        'latitude': latitude.toStringAsFixed(6),
        'longitude': longitude.toStringAsFixed(6),
        'fid': '0',
        'appType': '15',
        'ifTiJiao': '1',
        'deviceCode': _getDeviceCode(),
        'vpProbability': '-1',
        'vpStrategy': '',
        'currentFaceId': '',
        'ifCFP': '0',
      };
      if (validate != null) params['validate'] = validate;
      if (faceId != null) params['currentFaceId'] = faceId;

      final response = await _client.sendRequest(
        url,
        params: params,
        responseType: ResponseType.plain,
      );
      return SignInDto(result: response.data?.toString() ?? '');
    } catch (e) {
      debugPrint('locationSignIn error: $e');
      return null;
    }
  }

  Future<SignInDto?> qrCodeSignIn({
    required String courseId,
    required String activeId,
    required String enc,
    required String uid,
    required String name,
    String? address,
    double? latitude,
    double? longitude,
    String? enc2,
    String? validate,
    String? faceId,
  }) async {
    try {
      const url = 'https://mobilelearn.chaoxing.com/pptSign/stuSignajax';
      final params = <String, String>{
        'enc': enc,
        'name': name,
        'activeId': activeId,
        'uid': uid,
        'clientip': '',
        'location': '',
        'latitude': '-1',
        'longitude': '-1',
        'fid': '0',
        'appType': '15',
        'deviceCode': _getDeviceCode(),
        'vpProbability': '',
        'vpStrategy': '',
        'enc2': '',
        'validate': '',
        'currentFaceId': '',
        'ifCFP': '0',
        'courseId': courseId,
      };

      if (address != null && latitude != null && longitude != null) {
        final locationJson =
            '{"result":1,"latitude":$latitude,"longitude":$longitude,"mockData":{"strategy":0,"probability":-1},"address":"$address"}';
        params['location'] = locationJson;
      }

      if (enc2 != null && validate != null) {
        params['enc2'] = enc2;
        params['validate'] = validate;
      }

      if (faceId != null) params['currentFaceId'] = faceId;

      final response = await _client.sendRequest(
        url,
        params: params,
        responseType: ResponseType.plain,
      );
      return SignInDto(result: response.data?.toString() ?? '');
    } catch (e) {
      debugPrint('qrCodeSignIn error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSignDetail(String activeId) async {
    try {
      final url =
          'https://mobilelearn.chaoxing.com/newsign/signDetail?activePrimaryId=$activeId&type=1';
      final response = await _client.sendRequest(url);
      return response.data;
    } catch (e) {
      debugPrint('getSignDetail error: $e');
      return null;
    }
  }

  Future<bool?> checkQrCode({
    required String activeId,
    required String enc,
    String? enc2,
  }) async {
    try {
      const url =
          'https://mobilelearn.chaoxing.com/widget/sign/pcStuSignController/checkQrCode';
      final params = <String, String>{'activeId': activeId, 'enc': enc};
      if (enc2 != null) {
        params['enc2'] = enc2;
      }
      final response = await _client.sendRequest(url, params: params);
      return response.data['result'] == 1;
    } catch (e) {
      debugPrint('checkQrCode error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAttendInfo(String activeId) async {
    try {
      final url =
          'https://mobilelearn.chaoxing.com/v2/apis/sign/getAttendInfo?activeId=$activeId&moreClassAttendEnc=';
      final response = await _client.sendRequest(url);
      final data = response.data;
      if (data['result'] == 1) {
        return data['data'];
      }
      return null;
    } catch (e) {
      debugPrint('getAttendInfo error: $e');
      return null;
    }
  }

  Future<SignInDto?> groupSignIn({
    required String activeId,
    required String uid,
  }) async {
    try {
      const url = 'https://mobilelearn.chaoxing.com/sign/stuSignajax';
      final params = {
        'activeId': activeId,
        'uid': uid,
        'clientip': '10.0.85.108',
        'useragent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36',
      };

      final response = await _client.sendRequest(
        url,
        params: params,
        responseType: ResponseType.plain,
      );
      return SignInDto(result: response.data?.toString() ?? '');
    } catch (e) {
      debugPrint('groupSignIn error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> groupPreSignIn(String activeId) async {
    try {
      const url = 'https://mobilelearn.chaoxing.com/sign/preStuSign';
      final response = await _client.sendRequest(
        url,
        params: {'activeId': activeId},
      );
      return response.data;
    } catch (e) {
      debugPrint('groupPreSignIn error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSignReceipt(String activeId) async {
    try {
      final url =
          'https://mobilelearn.chaoxing.com/sign/signReceipt2?activeId=$activeId';
      final response = await _client.sendRequest(url);
      return response.data;
    } catch (e) {
      debugPrint('getSignReceipt error: $e');
      return null;
    }
  }

  static String _getDeviceCode() {
    return 'web_${DateTime.now().millisecondsSinceEpoch}';
  }
}
