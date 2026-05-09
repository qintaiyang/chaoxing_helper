import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../../../../app_dependencies.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../models/pan_file_dto.dart';

class CXPanApi {
  final AppDioClient _client;

  CXPanApi(this._client);

  String? _cachedToken;
  DateTime? _tokenExpiry;
  String? _cachedEnc;
  DateTime? _encExpiry;
  String? _cachedRootDir;
  DateTime? _rootDirExpiry;
  String? _cachedUploadToken;

  void clearCache() {
    _cachedToken = null;
    _tokenExpiry = null;
    _cachedEnc = null;
    _encExpiry = null;
    _cachedRootDir = null;
    _rootDirExpiry = null;
    _cachedUploadToken = null;
  }

  Future<String?> _getPanToken() async {
    if (_cachedToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _cachedToken;
    }

    try {
      const url = 'https://i.chaoxing.com/pan/getToken';
      debugPrint('🔑 请求云盘token...');
      final response = await _client.sendRequest(url, method: 'POST');
      if (response.data != null && response.data['status'] == true) {
        _cachedToken = response.data['token'];
        _tokenExpiry = DateTime.now().add(const Duration(hours: 1));
        debugPrint('✅ 云盘token获取成功: ${_cachedToken!.substring(0, 10)}...');
        await _saveCldiskCookies('p_auth_token', _cachedToken!);
        return _cachedToken;
      } else {
        debugPrint('❌ 云盘token获取失败: ${response.data}');
      }
    } catch (e) {
      debugPrint('❌ getPanToken error: $e');
    }
    return null;
  }

  Future<void> _saveCldiskCookies(String name, String value) async {
    try {
      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      if (session != null) {
        final cookieJar = AppDependencies.instance.cookieManager
            .getCurrentUserCookieJar(session);
        if (cookieJar != null) {
          final cookie = Cookie(name, value)
            ..domain = '.cldisk.com'
            ..path = '/'
            ..secure = true;
          await cookieJar.saveFromResponse(Uri.parse('https://cldisk.com'), [
            cookie,
          ]);
          debugPrint('_saveCldiskCookies: 保存 $name 到.cldisk.com域成功');
        }
      }
    } catch (e) {
      debugPrint('_saveCldiskCookies error: $e');
    }
  }

  Future<void> _doSsoAuth(String token) async {
    try {
      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';

      await _saveCldiskCookies('UID', puid);

      const ssoUrl = 'https://sso.chaoxing.com/apis/login/userLogin4Uname.do';
      debugPrint('_doSsoAuth: 访问SSO URL');
      await _client.sendRequest(
        ssoUrl,
        headers: {'p-auth-token': token},
        allowRedirects: true,
      );
    } catch (e) {
      debugPrint('_doSsoAuth error: $e');
    }
  }

  Future<String> _getEnc() async {
    if (_cachedEnc != null &&
        _encExpiry != null &&
        DateTime.now().isBefore(_encExpiry!)) {
      debugPrint('🔄 使用缓存的enc: ${_cachedEnc!.substring(0, 10)}...');
      return _cachedEnc!;
    }

    try {
      final token = await _getPanToken();
      if (token == null) {
        debugPrint('❌ _getEnc: token为空');
        return '';
      }

      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';
      debugPrint('🆔 puid: $puid');

      await _doSsoAuth(token);

      const url = 'https://pan-yz.cldisk.com/pcuserpan/index';
      final params = {'s': 'abc', 'uid': puid, 'p_auth_token': token};
      debugPrint('📡 请求enc URL: $url');

      final headers = {
        'p-auth-token': token,
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36',
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
        'Sec-Fetch-Dest': 'document',
        'Sec-Fetch-Mode': 'navigate',
        'Sec-Fetch-Site': 'none',
        'Sec-Fetch-User': '?1',
      };

      final response = await _client.sendRequest(
        url,
        params: params,
        options: Options(
          headers: headers,
          responseType: ResponseType.plain,
          sendTimeout: const Duration(seconds: 15),
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.data != null) {
        final html = response.data as String;
        debugPrint('📄 HTML长度: ${html.length}');

        final match = RegExp(
          r'''encstr\s*[:=]\s*['"]([a-f0-9]{32})['"]''',
        ).firstMatch(html);
        if (match != null) {
          _cachedEnc = match.group(1);
          _encExpiry = DateTime.now().add(const Duration(hours: 1));
          debugPrint('✅ enc获取成功: ${_cachedEnc!.substring(0, 10)}...');
        } else {
          debugPrint('❌ 未匹配到encstr正则');
        }

        final rootMatch = RegExp(
          r'''const\s+rootdir\s*=\s*['"](\d+)['"]''',
        ).firstMatch(html);
        if (rootMatch != null) {
          _cachedRootDir = rootMatch.group(1);
          _rootDirExpiry = DateTime.now().add(const Duration(hours: 1));
          debugPrint('✅ rootdir获取成功: $_cachedRootDir');
        } else {
          debugPrint('❌ 未匹配到rootdir正则');
        }

        final tokenMatch = RegExp(
          r'''const\s+_token\s*=\s*['"]([a-f0-9]{32})['"]''',
        ).firstMatch(html);
        if (tokenMatch != null) {
          _cachedUploadToken = tokenMatch.group(1);
          debugPrint('✅ upload_token获取成功');
        } else {
          debugPrint('❌ 未匹配到_token正则');
        }

        if (_cachedEnc != null) {
          return _cachedEnc!;
        }
      } else {
        debugPrint('❌ response.data为null');
      }
    } catch (e) {
      debugPrint('❌ 动态获取enc失败: $e');
    }

    return '';
  }

  Future<String> _getRootDir() async {
    if (_cachedRootDir != null &&
        _rootDirExpiry != null &&
        DateTime.now().isBefore(_rootDirExpiry!)) {
      return _cachedRootDir!;
    }

    await _getEnc();

    if (_cachedRootDir != null) {
      return _cachedRootDir!;
    }

    return '';
  }

  Future<List<PanFileDto>> getMyCloudFiles({
    String fldid = '0',
    int page = 1,
    int size = 20,
    String filterType = '',
    String orderField = 'default',
    String orderType = 'desc',
    String searchValue = '',
  }) async {
    try {
      debugPrint('📂 getMyCloudFiles开始: fldid=$fldid');
      final token = await _getPanToken();
      if (token == null) {
        debugPrint('❌ getMyCloudFiles: token为空');
        return [];
      }

      final enc = await _getEnc();
      if (enc.isEmpty) {
        debugPrint('❌ getMyCloudFiles: enc为空');
        return [];
      }

      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';

      String parentId = fldid;
      if (parentId == '0') {
        parentId = await _getRootDir();
        if (parentId.isEmpty) {
          debugPrint('❌ getMyCloudFiles: rootdir为空');
          return [];
        }
      }
      debugPrint('📁 parentId: $parentId');

      const url = 'https://pan-yz.cldisk.com/opt/listres';
      final params = <String, String>{
        'puid': puid,
        'shareid': '0',
        'parentId': parentId,
        'page': page.toString(),
        'size': size.toString(),
        'enc': enc,
        'filterType': filterType,
        'orderField': orderField,
        'orderType': orderType,
      };
      if (searchValue.isNotEmpty) {
        params['searchValue'] = searchValue;
      }
      debugPrint('📤 请求参数: $params');

      final headers = {
        'p-auth-token': token,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/index',
      };

      final response = await _client.sendRequest(
        url,
        params: params,
        headers: headers,
      );

      debugPrint('📥 响应数据: ${response.data}');
      final data = response.data;
      if (data is Map) {
        final list = data['list'];
        debugPrint('📋 list字段: $list');
        if (list is List) {
          debugPrint('✅ 解析到${list.length}个文件');
          return list
              .whereType<Map<String, dynamic>>()
              .map((e) => PanFileDto.fromJson(e))
              .toList();
        }
      }
      debugPrint('❌ 响应格式不正确');
      return [];
    } catch (e) {
      debugPrint('❌ getMyCloudFiles error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getCloudDownloadUrl({
    required String fleid,
    required String encryptedId,
    String currentFolderId = '0',
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';

      const url = 'https://pan-yz.cldisk.com/download/downloadFileV2';
      final params = {
        'fleid': fleid,
        'puid': puid,
        'currentFolderId': currentFolderId,
        'p_auth_token': token,
        'encryptedId': encryptedId,
        'auditRecordIdEnc': '',
      };

      final headers = {
        'p-auth-token': token,
        'Referer':
            'https://pan-yz.cldisk.com/pcuserpan/index?s=abc&uid=$puid&p_auth_token=$token',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36',
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
        'Accept-Language': 'zh-CN,zh;q=0.9',
      };

      final response = await _client.sendRequest(
        url,
        params: params,
        options: Options(
          headers: headers,
          followRedirects: false,
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode == 302 || response.statusCode == 301) {
        final locations = response.headers['location'];
        if (locations != null && locations.isNotEmpty) {
          return {'result': true, 'downloadUrl': locations.first};
        }
      }

      if (response.statusCode == 200) {
        return {'result': true, 'downloadUrl': response.realUri.toString()};
      }

      return null;
    } catch (e) {
      debugPrint('getCloudDownloadUrl error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCloudUploadUrl({String fldid = '0'}) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      String parentId = fldid;
      if (parentId == '0') {
        parentId = await _getRootDir();
        if (parentId.isEmpty) return null;
      }

      await _getEnc();
      if (_cachedUploadToken == null) return null;

      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';

      const url = 'https://pan-yz.cldisk.com/pcuserpanUpload/generateUploadUrl';
      final params = {
        'puid': puid,
        'folderUpload': 'false',
        'fldid': parentId,
        '_token': _cachedUploadToken!,
      };

      final headers = {
        'p-auth-token': token,
        'Referer':
            'https://pan-yz.cldisk.com/pcuserpan/upload?bigFile=0&yunpanFidEnc=&barrierFree=false&isSuperstarfirefly=&p_auth_token=$token',
        'X-Requested-With': 'XMLHttpRequest',
      };

      final response = await _client.sendRequest(
        url,
        params: params,
        headers: headers,
      );
      return response.data;
    } catch (e) {
      debugPrint('getCloudUploadUrl error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadFileToCloud({
    required String filePath,
    String fldid = '0',
    void Function(double progress)? onProgress,
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      String parentId = fldid;
      if (parentId == '0') {
        parentId = await _getRootDir();
        if (parentId.isEmpty) {
          debugPrint('获取rootdir失败');
          return {'result': false, 'msg': '获取根目录ID失败'};
        }
      }

      final uploadUrlResult = await getCloudUploadUrl(fldid: parentId);
      if (uploadUrlResult == null || uploadUrlResult['uploadUrl'] == null) {
        debugPrint('获取上传URL失败');
        return {'result': false, 'msg': '获取上传URL失败'};
      }

      final uploadUrl =
          'https://pan-yz.cldisk.com${uploadUrlResult['uploadUrl']}';
      debugPrint('上传URL: $uploadUrl');

      final file = File(filePath);
      final fileName = filePath.split(Platform.pathSeparator).last;

      final dio = Dio();
      dio.options.followRedirects = true;
      dio.options.maxRedirects = 5;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final headers = {
        'p-auth-token': token,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/upload',
        'Origin': 'https://pan-yz.cldisk.com',
        'X-Requested-With': 'XMLHttpRequest',
      };

      final response = await dio.post(
        uploadUrl,
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) => status != null && status < 500,
        ),
        onSendProgress: (sent, total) {
          if (total > 0 && onProgress != null) {
            final progress = sent / total;
            onProgress(progress);
          }
        },
      );

      debugPrint('上传响应: ${response.data}');

      if (response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else if (response.data is String) {
          final dataStr = response.data as String;
          if (dataStr.isNotEmpty && dataStr.startsWith('{')) {
            return jsonDecode(dataStr) as Map<String, dynamic>;
          }
        }
      }

      return {'result': false, 'msg': '上传失败: response为空'};
    } catch (e) {
      debugPrint('uploadFileToCloud error: $e');
      return {'result': false, 'msg': '上传异常: $e'};
    }
  }

  Future<Map<String, dynamic>?> createCloudFolder({
    required String name,
    String fldid = '0',
    String visibility = 'onlyme',
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      String parentId = fldid;
      if (parentId == '0') {
        parentId = await _getRootDir();
        if (parentId.isEmpty) {
          debugPrint('获取rootdir失败');
          return null;
        }
      }

      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';

      const url = 'https://pan-yz.cldisk.com/opt/newRootfolder';
      final formData = {
        'parentId': parentId,
        'name': name,
        'selectDlid': visibility,
        'newfileid': '0',
        'cx_p_token': '',
        'puid': puid,
      };
      debugPrint(
        '创建文件夹参数: parentId=$parentId, name=$name, visibility=$visibility, puid=$puid',
      );
      final headers = {
        'p-auth-token': token,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/index',
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
        headers: headers,
      );
      debugPrint('创建文件夹响应: ${response.data}');
      return response.data;
    } catch (e) {
      debugPrint('createCloudFolder error: $e');
    }
    return null;
  }

  Future<bool?> deleteCloudFiles({
    required String resids,
    required String encryptedId,
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';

      const url = 'https://pan-yz.cldisk.com/opt/delres';
      final formData = {
        'resids': resids,
        'resourcetype': '0',
        'puids': puid,
        'encryptedids': encryptedId,
      };

      final headers = {
        'p-auth-token': token,
        'Referer':
            'https://pan-yz.cldisk.com/pcuserpan/index?s=abc&uid=$puid&p_auth_token=$token',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
        headers: headers,
      );
      final data = response.data;
      debugPrint('📝 renameCloudFile 响应: $data');
      return data?['success'] == true || data?['result'] == true;
    } catch (e) {
      debugPrint('deleteCloudFiles error: $e');
      return null;
    }
  }

  Future<bool?> renameCloudFile({
    required String resids,
    required String name,
    required String encryptedId,
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';

      const url = 'https://pan-yz.cldisk.com/opt/rename';
      final formData = {
        'name': name,
        'resid': resids,
        'encryptedId': encryptedId,
        'puid': puid,
      };

      final headers = {
        'p-auth-token': token,
        'Referer':
            'https://pan-yz.cldisk.com/pcuserpan/index?s=abc&uid=$puid&p_auth_token=$token',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
        headers: headers,
      );
      final data = response.data;
      debugPrint('📝 renameCloudFile 响应: $data');
      return data?['success'] == true || data?['result'] == true;
    } catch (e) {
      debugPrint('renameCloudFile error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCloudRecyclebin({
    int page = 1,
    int size = 20,
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      const url = 'https://pan-yz.cldisk.com/recycle';
      final formData = {'page': page.toString(), 'size': size.toString()};
      final headers = {
        'p-auth-token': token,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/recycle',
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
        headers: headers,
      );
      return response.data;
    } catch (e) {
      debugPrint('getCloudRecyclebin error: $e');
      return null;
    }
  }

  Future<bool?> restoreCloudFiles({required String resids}) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;
      const url = 'https://pan-yz.cldisk.com/recycle/recover';
      final formData = {'resids': resids, 't': '0'};
      final headers = {
        'p-auth-token': token,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/index',
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
        headers: headers,
      );
      debugPrint('restoreCloudFiles 响应: ${response.data}');
      final data = response.data;
      if (data is Map) {
        return data['result'] == true || data['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('restoreCloudFiles error: $e');
      return null;
    }
  }

  Future<bool?> deleteRecycleFiles({required String resids}) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;
      const url = 'https://pan-yz.cldisk.com/recycle/delres';
      final formData = {'resids': resids};
      final headers = {
        'p-auth-token': token,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/recycle',
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
        headers: headers,
      );
      debugPrint('deleteRecycleFiles 响应: ${response.data}');
      final data = response.data;
      if (data is Map) {
        return data['result'] == true || data['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('deleteRecycleFiles error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> setupTop({
    required String resid,
    required String parentId,
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      final url =
          'https://pan-yz.cldisk.com/opt/setupTop?parentId=$parentId&fileinfoId=$resid';
      final headers = {
        'p-auth-token': token,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/index',
      };
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        headers: headers,
      );
      return response.data;
    } catch (e) {
      debugPrint('setupTop error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> cancelTop({
    required String resid,
    required String parentId,
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      final url =
          'https://pan-yz.cldisk.com/opt/cancalTop?parentId=$parentId&fileinfoId=$resid';
      final headers = {
        'p-auth-token': token,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/index',
      };
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        headers: headers,
      );
      return response.data;
    } catch (e) {
      debugPrint('cancelTop error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCloudFileInfo({
    required String fleids,
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      await _getEnc();
      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';

      const url = 'https://pan-yz.cldisk.com/pcuserpan/operation/fileinfo';
      final params = {
        'fleids': fleids,
        'puid': puid,
        '_token': _cachedUploadToken ?? '',
        'showShareInfo': 'true',
      };
      final headers = {
        'p-auth-token': token,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/index',
      };
      final response = await _client.sendRequest(
        url,
        params: params,
        headers: headers,
      );
      return response.data;
    } catch (e) {
      debugPrint('getCloudFileInfo error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> shareCloudFile({
    required String resids,
    required String encryptedId,
    String shareType = 'public',
    String? password,
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';

      const url = 'https://pan-yz.cldisk.com/share/createShareUrl';
      final formData = {
        'resids': resids,
        'encryptedids': encryptedId,
        'shareType': shareType,
        'password': password ?? '',
        'puid': puid,
      };
      final headers = {
        'p-auth-token': token,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/index',
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
        headers: headers,
      );
      return response.data;
    } catch (e) {
      debugPrint('shareCloudFile error: $e');
      return null;
    }
  }

  Future<String?> getImagePreviewUrl({required String resid}) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      final ts = DateTime.now().millisecondsSinceEpoch;
      return 'https://pan-yz.cldisk.com/preview/showpreview_$resid.html?v=$ts&_from=pcuserpan&p_auth_token=$token';
    } catch (e) {
      debugPrint('getImagePreviewUrl error: $e');
      return null;
    }
  }

  Future<String?> getPreviewUrl({
    required String resid,
    String encryptedId = '',
    bool isFavorite = false,
  }) async {
    try {
      final token = await _getPanToken();
      if (token == null) return null;

      final ts = DateTime.now().millisecondsSinceEpoch;

      var url = isFavorite
          ? 'https://pan-yz.cldisk.com/preview/showpreview_$resid.html?v=$ts&_from=pcuserpan&p_auth_token=$token'
          : 'https://pan-yz.cldisk.com/preview/onlyMySelfPreview_$resid.html?v=$ts&_from=pcuserpan&p_auth_token=$token';

      if (encryptedId.isNotEmpty) {
        url += '&enc=$encryptedId';
      }

      debugPrint('getPreviewUrl: $url');
      return url;
    } catch (e) {
      debugPrint('getPreviewUrl error: $e');
      return null;
    }
  }

  Future<String?> getUploadToken() async {
    await _getEnc();
    return _cachedUploadToken;
  }

  Future<String> computeFileCrc(File file) async {
    final digest = await md5.bind(file.openRead()).first;
    return digest.toString();
  }

  Future<bool> checkCrcExists(String crc, String token) async {
    try {
      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';
      final dio = Dio();
      final response = await dio.get(
        'https://pan-yz.chaoxing.com/api/crcStorageStatus',
        queryParameters: {'puid': puid, 'crc': crc, '_token': token},
      );
      final data = response.data;
      if (data is Map && data['exist'] == true) {
        debugPrint('[CXPanApi] CRC秒传命中: $crc');
        return true;
      }
    } catch (e) {
      debugPrint('[CXPanApi] CRC检查失败(继续上传): $e');
    }
    return false;
  }

  Future<Map<String, dynamic>?> uploadFileForChat(
    File file,
    String token,
    void Function(double) onProgress,
  ) async {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final dio = Dio();

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final session = AppDependencies.instance.accountRepo
        .getCurrentSessionId()
        .fold((_) => null, (id) => id);
    final puid = session ?? '';
    final response = await dio.post(
      'https://pan-yz.chaoxing.com/upload',
      queryParameters: {'_token': token, 'puid': puid},
      data: formData,
      options: Options(
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Referer': 'https://pan-yz.chaoxing.com/',
        },
      ),
      onSendProgress: (sent, total) {
        if (total > 0) {
          onProgress(sent / total);
        }
      },
    );

    final respData = response.data;
    if (respData is Map<String, dynamic>) {
      return respData;
    } else if (respData is String) {
      return jsonDecode(respData) as Map<String, dynamic>;
    }
    return null;
  }
}
