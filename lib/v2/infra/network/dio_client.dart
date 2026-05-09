import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../crypto/encryption_service.dart';
import '../crypto/crypto_config.dart';
import '../storage/cookie_manager.dart';
import '../storage/storage_service.dart';
import '../../domain/entities/enums.dart';
import '../../domain/repositories/storage_repository.dart';

class AppDioClient {
  late final Dio _dio;
  final EncryptionService _encryption;
  final CookieManager _cookieManager;
  final StorageRepository _storage;

  static const _brand = 'google';
  static const _deviceModel = 'Pixel 9 Pro';
  static const _systemVersion = '16';
  static const _buildNumber = '1610';
  static const _incremental = '14624737';
  static const _systemHttpAgent =
      'Dalvik/2.1.0 (Linux; U; Android 16; Pixel 9 Pro Build/BP4A.260205.002)';

  static const _rcVersion = '1.3.3';
  static const _cxProductId = '3';
  static const _cxVersion = '6.7.4';
  static const _cxVersionCode = '10940';
  static const _cxApiVersion = '314';

  static const _uniqueIdKey = 'app_unique_id';

  static const _serverBaseUrlMap = {
    RainClassroomServerType.yuketang: 'https://www.yuketang.cn',
    RainClassroomServerType.pro: 'https://pro.yuketang.cn',
    RainClassroomServerType.changjiang: 'https://changjiang.yuketang.cn',
    RainClassroomServerType.huanghe: 'https://huanghe.yuketang.cn',
  };

  AppDioClient({
    required EncryptionService encryption,
    required CookieManager cookieManager,
    required StorageRepository storage,
    required PlatformType platform,
    RainClassroomServerType? rcServer,
  }) : _encryption = encryption,
       _cookieManager = cookieManager,
       _storage = storage {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 10),
        followRedirects: false,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _applyPlatformConfig(platform, rcServer);

    _dio.interceptors.add(
      CookieInterceptor(cookieManager: _cookieManager, platform: platform),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args) {
          if (args.data.toString().contains('<html>')) return false;
          final sensitiveKeys = ['password', 'uname', 'logininfo', 'cookie'];
          final dataStr = args.data.toString().toLowerCase();
          for (final key in sensitiveKeys) {
            if (dataStr.contains(key)) return false;
          }
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );
  }

  Dio get dio => _dio;
  EncryptionService get encryption => _encryption;
  CookieManager get cookieManager => _cookieManager;
  StorageRepository get storage => _storage;

  void reconfigure({
    required PlatformType platform,
    RainClassroomServerType? rcServer,
  }) {
    _applyPlatformConfig(platform, rcServer);
  }

  Future<Response> sendRequest(
    String url, {
    String method = 'GET',
    Map<String, String>? params,
    Map<String, String>? headers,
    dynamic body,
    ResponseType responseType = ResponseType.json,
    bool allowRedirects = true,
    String? contentType,
    Options? options,
  }) async {
    final requestOptions = Options(
      method: options?.method ?? method,
      headers: options?.headers ?? headers,
      responseType: options?.responseType ?? responseType,
      contentType: options?.contentType ?? contentType,
      followRedirects: options?.followRedirects ?? allowRedirects,
      sendTimeout: options?.sendTimeout,
      connectTimeout: options?.connectTimeout,
      receiveTimeout: options?.receiveTimeout,
    );

    var response = await _dio.request(
      url,
      queryParameters: params,
      data: body,
      options: requestOptions,
    );

    if (requestOptions.followRedirects ?? allowRedirects) {
      int redirectCount = 0;
      const maxRedirects = 3;
      while (redirectCount < maxRedirects) {
        var locationUrl = response.headers['location']?.first;
        if (locationUrl == null) break;
        if (!locationUrl.startsWith('http')) {
          final uri = response.realUri;
          final baseUri =
              '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
          locationUrl = baseUri + locationUrl;
        }
        response = await _dio.get(locationUrl, options: requestOptions);
        redirectCount++;
      }
    }

    final finalResponseType = requestOptions.responseType ?? responseType;
    if (finalResponseType == ResponseType.json && response.data is String) {
      final dataStr = (response.data as String).trim();
      if (!(dataStr.startsWith('{') || dataStr.startsWith('['))) {
        debugPrint(
          '⚠️ JSON响应是HTML，保持原始文本: ${dataStr.substring(0, dataStr.length > 200 ? 200 : dataStr.length)}...',
        );
      } else {
        try {
          response.data = jsonDecode(response.data);
        } catch (_) {}
      }
    }

    return response;
  }

  void _applyPlatformConfig(
    PlatformType platform,
    RainClassroomServerType? rcServer,
  ) {
    if (platform == PlatformType.chaoxing) {
      _dio.options.baseUrl = '';
      _dio.options.headers = _buildChaoxingHeaders();
    } else {
      _dio.options.baseUrl =
          _serverBaseUrlMap[rcServer ?? RainClassroomServerType.yuketang]!;
      _dio.options.headers = _buildRainClassroomHeaders();
    }
  }

  Map<String, String> _buildChaoxingHeaders() {
    String uniqueId = _storage.getStringSync(_uniqueIdKey) ?? '';
    if (uniqueId.isEmpty) {
      uniqueId = _encryption.getUniqueId();
      _storage.setString(_uniqueIdKey, uniqueId);
    }
    final userAgentTemp =
        '(device:$_deviceModel) Language/zh_CN com.chaoxing.mobile/ChaoXingStudy_${_cxProductId}_${_cxVersion}_android_phone_${_cxVersionCode}_$_cxApiVersion (@Kalimdor)_$uniqueId';
    final schild = _encryption.md5Hash(
      '(schild:${CryptoConfig.production.schildSalt}) $userAgentTemp',
    );
    final userAgent = '$_systemHttpAgent (schild:$schild) $userAgentTemp';
    return {
      'User-Agent': userAgent,
      'Accept-Language': 'zh_CN',
      'Connection': 'keep-alive',
      'Accept-Encoding': 'gzip',
      'content-type': 'application/x-www-form-urlencoded',
    };
  }

  Map<String, String> _buildRainClassroomHeaders() {
    return {
      'user-agent': 'Android',
      'brand': '$_brand $_deviceModel',
      'uuid': '',
      'buildnumber': _buildNumber,
      'xtua': 'client=app&tag=$_rcVersion&platform=Android',
      'systemversion': _systemVersion,
      'incremental': _incremental,
      'accept': 'application/json',
      'isphysicaldevice': 'true',
      'xtbz': 'ykt',
      'x-client': 'app',
    };
  }
}

class CookieInterceptor extends Interceptor {
  static const _sessionKey = 'chaoxing_current_session';
  static const _chaoxingHubHosts = [
    'www.chaoxing.com',
    'passport2.chaoxing.com',
    'mooc1-api.chaoxing.com',
    'mooc1.chaoxing.com',
    'mooc1-1.chaoxing.com',
    'i.chaoxing.com',
    'learn.chaoxing.com',
    'photo.chaoxing.com',
    'im.chaoxing.com',
    'sso.chaoxing.com',
    'passport2-api.chaoxing.com',
    'mobilelearn.chaoxing.com',
    'pan-yz.chaoxing.com',
  ];

  final CookieManager _cookieManager;
  final PlatformType _platform;
  final ValueNotifier<bool> isLoggingIn;

  CookieInterceptor({
    required CookieManager cookieManager,
    required PlatformType platform,
    ValueNotifier<bool>? isLoggingInNotifier,
  }) : _cookieManager = cookieManager,
       _platform = platform,
       isLoggingIn = isLoggingInNotifier ?? ValueNotifier(false);

  String? get _currentUserId {
    final cookieManager = _cookieManager;
    final overrideUserId = cookieManager.getOverrideUserId();
    if (overrideUserId != null) return overrideUserId;
    final storage = SharedPreferencesStorage.instance;
    return storage.getStringSync(_sessionKey);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers['Cookie'] != null) {
      handler.next(options);
      return;
    }

    final uri = options.uri;
    List<Cookie> cookies = [];
    CookieJar? cookieJar;

    if (isLoggingIn.value) {
      cookieJar = _cookieManager.getTempCookieJar();
    } else {
      final currentUserId = _currentUserId;
      if (currentUserId != null && currentUserId.isNotEmpty) {
        cookieJar = await _cookieManager.getCookieJarForUser(
          currentUserId,
          platform: _platform,
        );
      }
    }

    if (cookieJar != null) {
      cookies = await cookieJar.loadForRequest(uri);
    }

    if (_platform == PlatformType.chaoxing &&
        uri.host.endsWith('.chaoxing.com')) {
      final existingNames = cookies.map((c) => c.name).toSet();
      for (final host in _chaoxingHubHosts) {
        if (host == uri.host) continue;
        if (cookieJar == null) break;
        final hubCookies = await cookieJar.loadForRequest(
          Uri.parse('https://$host'),
        );
        for (final c in hubCookies) {
          if (!existingNames.contains(c.name)) {
            cookies.add(c);
            existingNames.add(c.name);
          }
        }
      }
    }

    if (cookies.isNotEmpty) {
      final cookieStr = cookies.map((c) => '${c.name}=${c.value}').join('; ');
      options.headers['Cookie'] = cookieStr;

      if (_platform == PlatformType.rainClassroom) {
        final cookieMap = Map.fromEntries(
          cookies.map((c) => MapEntry(c.name, c.value)),
        );
        if (cookieMap.containsKey('sid')) {
          options.headers['x-csrftoken'] = cookieMap['x-csrftoken'];
          options.headers['x-uid'] = cookieMap['x-uid'];
          options.headers['sessionid'] = cookieMap['sessionid'];
        } else {
          options.headers['x-client'] = 'web';
          options.headers['xt-agent'] = 'web';
        }
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final setCookieHeaders = response.headers['set-cookie'];
    if (setCookieHeaders != null) {
      final cookies = setCookieHeaders
          .map((s) => Cookie.fromSetCookieValue(s))
          .toList();

      if (isLoggingIn.value) {
        await _cookieManager.tempSaveCookie(cookies, platform: _platform);
      } else {
        final currentUserId = _currentUserId;
        if (currentUserId != null) {
          final cookieJar = await _cookieManager.getCookieJarForUser(
            currentUserId,
            platform: _platform,
          );
          await cookieJar.saveFromResponse(response.realUri, cookies);

          if (_platform == PlatformType.chaoxing &&
              response.realUri.host.endsWith('.chaoxing.com')) {
            for (final host in _chaoxingHubHosts) {
              final hubUri = Uri.parse('https://$host');
              await cookieJar.saveFromResponse(hubUri, cookies);
            }
          }

          await _cookieManager.saveCookiesForUser(
            currentUserId,
            platform: _platform,
          );
        }
      }
    }
    handler.next(response);
  }
}
