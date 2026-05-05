import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../models/homework_dto.dart';

class CXHomeworkApi {
  final AppDioClient _client;

  CXHomeworkApi(this._client);

  static const _browserUa =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36';

  Future<List<HomeworkDto>> getHomeworkList({
    required String courseId,
    required String classId,
    required String cpi,
  }) async {
    try {
      String enc = '';
      String workEnc = '';
      String t = DateTime.now().millisecondsSinceEpoch.toString();
      String finalUrl = '';

      try {
        final startUrl =
            'https://mooc1-1.chaoxing.com/mooc-ans/visit/stucoursemiddle?'
            'courseid=$courseId&clazzid=$classId&vc=1&cpi=$cpi&ismooc2=1&v=2';

        String currentUrl = startUrl;
        String referer = 'https://mooc1-1.chaoxing.com/visit/courselistdata';
        const maxRedirects = 10;

        for (int i = 0; i < maxRedirects; i++) {
          final response = await _client.sendRequest(
            currentUrl,
            options: Options(
              responseType: ResponseType.plain,
              followRedirects: false,
              validateStatus: (status) => status != null && status < 400,
              headers: {'User-Agent': _browserUa, 'Referer': referer},
            ),
          );

          final statusCode = response.statusCode;

          if (statusCode == 302 ||
              statusCode == 301 ||
              statusCode == 303 ||
              statusCode == 307 ||
              statusCode == 308) {
            String location = response.headers['location']?.firstOrNull ?? '';

            if (location.contains('login') || location.contains('passport')) {
              return [];
            }

            if (location.startsWith('/')) {
              final baseUri = Uri.parse(currentUrl);
              location = '${baseUri.scheme}://${baseUri.host}$location';
            } else if (!location.startsWith('http')) {
              final baseUri = Uri.parse(currentUrl);
              final path = baseUri.path;
              final lastSlash = path.lastIndexOf('/');
              if (lastSlash > 0) {
                location =
                    '${baseUri.scheme}://${baseUri.host}${path.substring(0, lastSlash + 1)}$location';
              }
            }

            referer = currentUrl;
            currentUrl = location;
            continue;
          }

          if (statusCode == 200 && response.data is String) {
            final html = response.data as String;
            finalUrl = currentUrl;

            final encMatch = RegExp(
              r'<input[^>]*id="enc"[^>]*value="([^"]*)"',
            ).firstMatch(html);
            final workEncMatch = RegExp(
              r'<input[^>]*id="workEnc"[^>]*value="([^"]*)"',
            ).firstMatch(html);
            final tMatch = RegExp(
              r'<input[^>]*id="t"[^>]*value="([^"]*)"',
            ).firstMatch(html);

            enc = encMatch?.group(1) ?? '';
            workEnc = workEncMatch?.group(1) ?? enc;
            t = tMatch?.group(1) ?? t;

            if (enc.isEmpty) {
              final urlEncMatch = RegExp(
                r'[?&]enc=([^&]+)',
              ).firstMatch(finalUrl);
              final urlTMatch = RegExp(r'[?&]t=(\d+)').firstMatch(finalUrl);
              enc = urlEncMatch?.group(1) ?? '';
              t = urlTMatch?.group(1) ?? t;
              workEnc = enc;
            }

            if (html.contains('无权限') || html.contains('login')) {
              return [];
            }
            break;
          }

          break;
        }
      } catch (e) {
        debugPrint('获取课程页面参数失败: $e');
      }

      if (enc.isEmpty) {
        return [];
      }

      final refererUrl = finalUrl.isNotEmpty
          ? finalUrl
          : 'https://mooc2-ans.chaoxing.com/mooc2-ans/mycourse/stu?courseid=$courseId&clazzid=$classId&cpi=$cpi&enc=$enc&t=$t&pageHeader=8&v=2&hideHead=0';

      final listUrl =
          'https://mooc1.chaoxing.com/mooc2/work/list?courseId=$courseId&classId=$classId&cpi=$cpi&ut=s&t=$t&stuenc=$enc&enc=$workEnc';

      for (int retry = 0; retry < 3; retry++) {
        if (retry > 0) {
          await Future.delayed(const Duration(seconds: 2));
        }

        final response = await _client.sendRequest(
          listUrl,
          options: Options(
            responseType: ResponseType.plain,
            followRedirects: false,
            validateStatus: (status) => status != null && status < 400,
            headers: {'User-Agent': _browserUa, 'Referer': refererUrl},
          ),
        );

        if (response.statusCode == 200 && response.data is String) {
          final html = response.data as String;

          if (html.contains('登录') ||
              html.contains('login') ||
              html.contains('passport')) {
            return [];
          }

          if (html.contains('无权限')) {
            return [];
          }

          return _parseWorkList(html, courseId, classId, cpi);
        }

        if (response.statusCode == 302 || response.statusCode == 301) {
          final location = response.headers['location']?.firstOrNull ?? '';
          if (location.contains('login') || location.contains('passport')) {
            return [];
          }
        }
      }

      return [];
    } catch (e) {
      debugPrint('getHomeworkList error: $e');
      return [];
    }
  }

  List<HomeworkDto> _parseWorkList(
    String html,
    String courseId,
    String classId,
    String cpi,
  ) {
    final list = <HomeworkDto>[];

    try {
      final liPattern = RegExp(
        r'<li[^>]*onclick="goTask\(this\);?"[^>]*data="([^"]*)"[^>]*>(.+?)</li>',
        multiLine: true,
        dotAll: true,
      );

      for (final match in liPattern.allMatches(html)) {
        final taskUrl = match.group(1) ?? '';
        final liContent = match.group(2) ?? '';

        String workId = '';
        String enc = '';
        String answerId = '';

        final workIdMatch = RegExp(r'workId=([^&]+)').firstMatch(taskUrl);
        if (workIdMatch != null) workId = workIdMatch.group(1) ?? '';

        final encMatch = RegExp(r'enc=([^&]+)').firstMatch(taskUrl);
        if (encMatch != null) enc = encMatch.group(1) ?? '';

        final answerIdMatch = RegExp(r'answerId=([^&]+)').firstMatch(taskUrl);
        if (answerIdMatch != null) answerId = answerIdMatch.group(1) ?? '';

        final titleMatch = RegExp(
          r'<p[^>]*class="overHidden2[^"]*"[^>]*>([^<]+)</p>',
        ).firstMatch(liContent);
        final title = titleMatch?.group(1)?.trim() ?? '未知作业';

        final statusMatch = RegExp(
          r'<p[^>]*class="status[^"]*"[^>]*>([^<]+)</p>',
        ).firstMatch(liContent);
        final status = statusMatch?.group(1)?.trim() ?? '';

        list.add(
          HomeworkDto(
            workId: workId,
            courseId: courseId,
            classId: classId,
            cpi: cpi,
            title: title,
            status: status,
            enc: enc,
            answerId: answerId,
            taskUrl: taskUrl,
          ),
        );
      }
    } catch (e) {
      debugPrint('_parseWorkList error: $e');
    }

    return list;
  }
}
