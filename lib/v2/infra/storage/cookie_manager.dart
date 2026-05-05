import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/enums.dart';
import '../../domain/repositories/storage_repository.dart';

class CookieManager {
  final StorageRepository _storage;
  final Map<String, CookieJar> _userCookieJars = {};
  CookieJar? _tempCookieJar;

  static const cxDomain = '.chaoxing.com';
  static const rcDomain = '.yuketang.cn';

  static const _hubHosts = [
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
  ];

  CookieManager(this._storage);

  Future<CookieJar> getCookieJarForUser(
    String userId, {
    PlatformType platform = PlatformType.chaoxing,
  }) async {
    if (_userCookieJars.containsKey(userId)) {
      return _userCookieJars[userId]!;
    }
    final cookieJar = CookieJar();
    _userCookieJars[userId] = cookieJar;
    await _loadCookiesForUser(userId, cookieJar);
    return cookieJar;
  }

  CookieJar getTempCookieJar() {
    return _tempCookieJar ??= CookieJar();
  }

  Future<void> tempSaveCookie(
    List<Cookie> cookies, {
    PlatformType platform = PlatformType.chaoxing,
  }) async {
    _tempCookieJar ??= CookieJar();
    for (var cookie in cookies) {
      late Uri uri;
      if (cookie.domain != null && cookie.domain!.isNotEmpty) {
        uri = Uri.parse('https://${cookie.domain}');
      } else {
        uri = _getDomainUri(platform);
        cookie.domain = uri.host;
      }
      await _tempCookieJar!.saveFromResponse(uri, [cookie]);
    }
  }

  Future<void> saveTempCookiesToUser(
    String userId, {
    PlatformType platform = PlatformType.chaoxing,
  }) async {
    final tempJar = _tempCookieJar;
    if (tempJar == null) {
      debugPrint('⚠️ saveTempCookiesToUser: tempJar为null');
      return;
    }
    final targetJar = await getCookieJarForUser(userId, platform: platform);
    final domainUri = _getDomainUri(platform);
    final tempCookies = await tempJar.loadForRequest(domainUri);
    debugPrint(
      '🍪 saveTempCookiesToUser: 找到 ${tempCookies.length} 个临时cookie, userId=$userId',
    );

    if (tempCookies.isEmpty) {
      for (final host in _hubHosts) {
        final hubCookies = await tempJar.loadForRequest(
          Uri.parse('https://$host'),
        );
        if (hubCookies.isNotEmpty) {
          debugPrint('🍪 从host $host 找到 ${hubCookies.length} 个cookie');
        }
        for (var cookie in hubCookies) {
          if (!tempCookies.any(
            (c) => c.name == cookie.name && c.value == cookie.value,
          )) {
            tempCookies.add(cookie);
          }
        }
      }
    }

    for (var cookie in tempCookies) {
      for (final host in _hubHosts) {
        try {
          final hubUri = Uri.parse('https://$host');
          await targetJar.saveFromResponse(hubUri, [cookie]);
        } catch (_) {}
      }
      if (cookie.domain != null && cookie.domain!.isNotEmpty) {
        try {
          final uri = Uri.parse('https://${cookie.domain}');
          await targetJar.saveFromResponse(uri, [cookie]);
        } catch (_) {}
      }
    }

    await saveCookiesForUser(userId, platform: platform);
    debugPrint('✅ Cookie迁移完成: ${tempCookies.length} 个cookie已保存到用户 $userId');
  }

  Future<void> saveCookiesForUser(
    String userId, {
    PlatformType platform = PlatformType.chaoxing,
  }) async {
    final jar = await getCookieJarForUser(userId, platform: platform);
    final domainUri = _getDomainUri(platform);
    final cookies = await jar.loadForRequest(domainUri);
    final List<Map<String, dynamic>> cookiesData = [];
    for (var cookie in cookies) {
      cookiesData.add({
        'name': cookie.name,
        'value': cookie.value,
        'domain':
            cookie.domain ??
            (platform == PlatformType.chaoxing ? cxDomain : rcDomain),
        'path': cookie.path ?? '/',
        'secure': cookie.secure,
        'httpOnly': cookie.httpOnly,
      });
    }
    await _storage.setString('cookies_$userId', json.encode(cookiesData));
  }

  Future<void> clearCookiesForUser(String userId) async {
    _userCookieJars.remove(userId);
    await _storage.remove('cookies_$userId');
  }

  CookieJar? getCurrentUserCookieJar(String? userId) {
    if (userId == null || userId.isEmpty) return null;
    return _userCookieJars[userId];
  }

  Uri _getDomainUri(PlatformType platform) {
    return platform == PlatformType.chaoxing
        ? Uri.parse('https://www.chaoxing.com')
        : Uri.parse('https://www.yuketang.cn');
  }

  Future<void> _loadCookiesForUser(String userId, CookieJar cookieJar) async {
    final result = await _storage.getString('cookies_$userId');
    final cookiesJson = result.fold((_) => null, (v) => v);
    if (cookiesJson == null) return;
    try {
      final List<dynamic> cookiesData = json.decode(cookiesJson);
      for (var cookieData in cookiesData) {
        final cookie = Cookie(
          cookieData['name'] as String,
          cookieData['value'] as String,
        );
        if (cookieData.containsKey('domain') && cookieData['domain'] != null) {
          cookie.domain = cookieData['domain'] as String;
        }
        if (cookieData.containsKey('path') && cookieData['path'] != null) {
          cookie.path = cookieData['path'] as String;
        }
        if (cookieData.containsKey('secure') && cookieData['secure'] != null) {
          cookie.secure = cookieData['secure'] as bool;
        }
        if (cookieData.containsKey('httpOnly') &&
            cookieData['httpOnly'] != null) {
          cookie.httpOnly = cookieData['httpOnly'] as bool;
        }
        if (cookie.domain != null && cookie.domain!.isNotEmpty) {
          final uri = Uri.parse('https://${cookie.domain}');
          await cookieJar.saveFromResponse(uri, [cookie]);
        }
      }
    } catch (e) {
      debugPrint('用户 $userId 的 Cookie 加载失败：$e');
    }
  }
}
