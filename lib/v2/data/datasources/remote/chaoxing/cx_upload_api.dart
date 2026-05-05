import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../../infra/network/dio_client.dart';

class CXUploadApi {
  final AppDioClient _client;

  CXUploadApi(this._client);

  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      const tokenUrl = 'https://pan-yz.chaoxing.com/api/token/uservalid';
      final tokenResponse = await _client.sendRequest(tokenUrl);

      if (tokenResponse.data == null) {
        debugPrint('Failed to get token');
        return null;
      }
      final String token = tokenResponse.data['_token'];

      const crcUrl = 'https://pan-yz.chaoxing.com/api/crcStorageStatus';
      final crc = await _getCRC(imageFile);
      final crcParams = {
        'puid': userId,
        'crc': crc,
        '_token': token,
      };
      await _client.sendRequest(crcUrl, params: crcParams);

      final now = DateTime.now();
      final timestamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
      final milliseconds = now.millisecond.toString().padLeft(3, '0');
      final fileName = '$timestamp$milliseconds.jpg';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path, filename: fileName),
        'puid': userId,
      });

      final uploadUrl =
          'https://pan-yz.chaoxing.com/upload?_from=mobilelearn&_token=$token';

      final uploadResponse = await _client.sendRequest(
        uploadUrl,
        method: 'POST',
        body: formData,
      );
      final objectId = uploadResponse.data['data']['objectId'] as String;

      return objectId;
    } catch (e) {
      debugPrint('CXUploadApi.uploadImage error: $e');
      return null;
    }
  }

  static String getImageUrl(String objectId) {
    return 'https://p.ananas.chaoxing.com/star4/$objectId/origin.jpg';
  }

  static String toNewImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      if (pathSegments.length >= 3) {
        final size = pathSegments[1];
        final fileNameWithExt = pathSegments[2];

        final lastDotIndex = fileNameWithExt.lastIndexOf('.');
        if (lastDotIndex != -1) {
          final filename = fileNameWithExt.substring(0, lastDotIndex);
          final extension = fileNameWithExt.substring(lastDotIndex);
          return '${uri.scheme}://${uri.host}/star4/$filename/$size$extension';
        } else {
          return '${uri.scheme}://${uri.host}/star4/$fileNameWithExt/$size.png';
        }
      }
    } catch (e) {
      debugPrint('URL转换失败: $e');
    }
    return url;
  }

  Future<String> _getCRC(File file) async {
    final bytes = await file.readAsBytes();
    int crc = 0xFFFFFFFF;
    for (final byte in bytes) {
      crc ^= byte;
      for (int i = 0; i < 8; i++) {
        if ((crc & 1) != 0) {
          crc = (crc >> 1) ^ 0xEDB88320;
        } else {
          crc = crc >> 1;
        }
      }
    }
    return (crc ^ 0xFFFFFFFF).toRadixString(16).toUpperCase().padLeft(8, '0');
  }
}
