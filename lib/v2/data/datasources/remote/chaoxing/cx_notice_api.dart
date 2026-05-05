import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../../infra/crypto/crypto_config.dart';
import '../../../models/notice_dto.dart';

class CXNoticeApi {
  final AppDioClient _client;

  CXNoticeApi(this._client);

  static const _noticeBaseUrl = 'https://notice.chaoxing.com';

  Future<List<Map<String, dynamic>>> syncUserNotices({
    required String puid,
  }) async {
    return _fetchNoticesOnce(puid: puid);
  }

  Future<List<Map<String, dynamic>>> _fetchNoticesOnce({
    required String puid,
    int maxW = 1000,
  }) async {
    try {
      final result = await _callNoticeApi(
        path: '/apis/notice/pullNoticeData_v2',
        puid: puid,
        extraParams: {
          'maxW': maxW.toString(),
          'lastTime': '0',
          'lastId': '0',
          'tagTime': '0',
        },
      );

      if (result == null || result['result'] != 1) {
        return [];
      }

      final data = result['data'] as Map<String, dynamic>?;
      if (data == null) return [];

      final list = data['list'] as List<dynamic>? ?? [];
      return List<Map<String, dynamic>>.from(list);
    } catch (e) {
      debugPrint('_fetchNoticesOnce error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> checkNoticeStatus({
    required String puid,
  }) async {
    return _callNoticeApi(path: '/apis/notice/getDataChangeStatus', puid: puid);
  }

  Future<Map<String, dynamic>?> _callNoticeApi({
    required String path,
    required String puid,
    Map<String, dynamic>? extraParams,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uuid = _generateUUID();

      final params = <String, dynamic>{
        'puid': puid,
        if (extraParams != null) ...extraParams,
      };

      final infEnc = _generateInfEnc(params, uuid, timestamp);

      final response = await _client.sendRequest(
        '$_noticeBaseUrl$path',
        params: {
          ...params.map((k, v) => MapEntry(k, v.toString())),
          '_c_0_': uuid,
          'token': CryptoConfig.production.infEncToken,
          '_time': timestamp.toString(),
          'inf_enc': infEnc,
        },
        responseType: ResponseType.json,
      );

      return response.data as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('_callNoticeApi error ($path): $e');
      return null;
    }
  }

  Future<List<NoticeDto>> getCourseNotices({
    required String courseId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      const url = 'https://structureyd.chaoxing.com/apis/notice/getNoticeList';
      final response = await _client.sendRequest(
        url,
        params: {
          'courseId': courseId,
          'page': page.toString(),
          'pageSize': pageSize.toString(),
        },
      );
      final data = response.data;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => NoticeDto.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('getCourseNotices error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getNoticeDetail({
    required String noticeId,
    String idCode = '',
  }) async {
    try {
      const url = 'https://structureyd.chaoxing.com/apis/notice/getNotice';
      final response = await _client.sendRequest(
        url,
        params: {'noticeId': noticeId, 'idCode': idCode},
      );
      return response.data;
    } catch (e) {
      debugPrint('getNoticeDetail error: $e');
      return null;
    }
  }

  Future<bool> readNotice({required String noticeId}) async {
    try {
      const url = 'https://structureyd.chaoxing.com/apis/notice/readNotice';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: {'noticeId': noticeId},
      );
      return response.data?['result'] == 1;
    } catch (e) {
      debugPrint('readNotice error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getNoticeFolders({
    required String courseId,
  }) async {
    try {
      const url = 'https://structureyd.chaoxing.com/apis/notice/getFolders';
      final response = await _client.sendRequest(
        url,
        params: {'courseId': courseId},
      );
      final data = response.data;
      if (data is Map && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return [];
    } catch (e) {
      debugPrint('getNoticeFolders error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> noticePage({
    String courseId = '',
    String classId = '',
  }) async {
    try {
      const url =
          'https://mobilelearn.chaoxing.com/noticeselection/produceview';
      final response = await _client.sendRequest(
        url,
        params: {'courseId': courseId, 'classId': classId},
        responseType: ResponseType.plain,
      );
      final data = response.data?.toString() ?? '';
      if (data.trimLeft().startsWith('{')) {
        return jsonDecode(data);
      }
      return null;
    } catch (e) {
      debugPrint('noticePage error: $e');
      return null;
    }
  }

  static String _generateInfEnc(
    Map<String, dynamic> params,
    String uuid,
    int timestamp,
  ) {
    final ordered = params.entries.toList();
    ordered.add(MapEntry('_c_0_', uuid));
    ordered.add(MapEntry('token', CryptoConfig.production.infEncToken));
    ordered.add(MapEntry('_time', timestamp.toString()));

    final parts = <String>[];
    for (final entry in ordered) {
      if (entry.value != null) {
        final encoded = _urlEncode(entry.value.toString());
        parts.add('${entry.key}=$encoded');
      }
    }
    parts.add('DESKey=${CryptoConfig.production.infEncKey}');
    return _md5Hash(parts.join('&'));
  }

  static String _urlEncode(String input) {
    const unreserved =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~';
    final result = StringBuffer();
    for (final codeUnit in input.codeUnits) {
      final char = String.fromCharCode(codeUnit);
      if (unreserved.contains(char)) {
        result.write(char);
      } else {
        result.write(
          '%${codeUnit.toRadixString(16).toUpperCase().padLeft(2, '0')}',
        );
      }
    }
    return result.toString();
  }

  static String _md5Hash(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  static String _generateUUID() {
    return DateTime.now().millisecondsSinceEpoch.toRadixString(36) +
        DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  }
}
