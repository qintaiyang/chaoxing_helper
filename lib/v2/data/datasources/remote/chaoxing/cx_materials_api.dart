import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../models/material_dto.dart';

class CXMaterialsApi {
  final AppDioClient _client;

  CXMaterialsApi(this._client);

  String? _cachedToken;
  DateTime? _tokenExpiry;

  Future<List<MaterialDto>> getCourseMaterials({
    required String courseId,
    required String classId,
    required String cpi,
    String? rootId,
    int pageNum = 1,
  }) async {
    try {
      const url = 'https://mooc1-api.chaoxing.com/phone/data/student-datalist';
      final response = await _client.sendRequest(
        url,
        params: {
          'courseId': courseId,
          'classId': classId,
          'cpi': cpi,
          'rootId': rootId ?? 'null',
          'pageNum': pageNum.toString(),
          'require': '',
          'microTopicId': '',
        },
      );

      final data = response.data;
      if (data is Map && data['result'] == 1 && data['data'] is List) {
        return (data['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => MaterialDto.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('getCourseMaterials error: $e');
      return [];
    }
  }

  Future<String?> _getDownloadToken() async {
    if (_cachedToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _cachedToken;
    }

    try {
      const url = 'https://pan-yz.chaoxing.com/api/token/uservalid';
      final response = await _client.sendRequest(url);
      final data = response.data;
      if (data is Map && data['result'] == true) {
        _cachedToken = data['_token'] as String?;
        _tokenExpiry = DateTime.now().add(const Duration(minutes: 30));
        return _cachedToken;
      }
    } catch (e) {
      debugPrint('_getDownloadToken error: $e');
    }
    return null;
  }

  Future<Map<String, String?>> _getMaterialUrls({
    required String objectId,
    required int puid,
    required int sarepuid,
    String? fileName,
  }) async {
    try {
      final token = await _getDownloadToken();
      if (token == null) {
        debugPrint('_getMaterialUrls: token获取失败');
        return {'download': null, 'preview': null};
      }

      const url = 'https://pan-yz.chaoxing.com/api/share/downloadUrl';
      final response = await _client.sendRequest(
        url,
        params: {
          'puid': puid.toString(),
          'sarepuid': sarepuid.toString(),
          'objectid': objectId,
          'fleid': '',
          '_token': token,
        },
      );

      final data = response.data;
      debugPrint(
        '_getMaterialUrls response: result=${data?['result']}, code=${data?['code']}',
      );
      if (data is Map && data['result'] == true) {
        final downloadUrl = data['url'] as String?;
        final previewUrl = data['objectIdPreviewUrl'] as String?;
        debugPrint('downloadUrl: $downloadUrl');
        debugPrint('previewUrl: $previewUrl');
        return {'download': downloadUrl, 'preview': previewUrl};
      } else {
        debugPrint(
          '_getMaterialUrls failed: code=${data?['code']}, msg=${data?['msg']}',
        );
      }
    } catch (e) {
      debugPrint('_getMaterialUrls error: $e');
    }
    return {'download': null, 'preview': null};
  }

  Future<String?> getMaterialPreviewUrl({
    required String objectId,
    required int puid,
    required int sarepuid,
    String? fileName,
  }) async {
    final urls = await _getMaterialUrls(
      objectId: objectId,
      puid: puid,
      sarepuid: sarepuid,
      fileName: fileName,
    );
    return urls['preview'];
  }

  Future<String?> getMaterialDownloadUrl({
    required String objectId,
    required int puid,
    required int sarepuid,
    String? fileName,
  }) async {
    final urls = await _getMaterialUrls(
      objectId: objectId,
      puid: puid,
      sarepuid: sarepuid,
      fileName: fileName,
    );
    return urls['download'];
  }
}
