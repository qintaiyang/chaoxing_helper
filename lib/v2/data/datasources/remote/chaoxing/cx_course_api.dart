import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../../infra/crypto/encryption_service.dart';
import '../../../models/course_dto.dart';
import '../../../models/active_dto.dart';
import '../../../models/homework_dto.dart';

class CXCourseApi {
  final AppDioClient _client;
  final EncryptionService _encryption;

  CXCourseApi(this._client, this._encryption);

  static const _browserUa =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36';

  Future<List<CourseDto>> getCourses() async {
    try {
      const url =
          'https://mooc1-api.chaoxing.com/mycourse/backclazzdata?view=json&getTchClazzType=1&mcode=';
      final response = await _client.sendRequest(url);
      final data = response.data;
      if (data is! Map || data['result'] != 1 || data['channelList'] is! List) {
        return [];
      }
      final courses = <CourseDto>[];
      for (var channel in (data['channelList'] as List)) {
        if (channel is! Map) continue;
        final content = channel['content'];
        if (content is! Map) continue;
        final courseData = _extractCourseData(content);
        if (courseData == null) continue;
        final state = content['state'];
        final isActive = state is int ? state == 1 || state == 0 : true;
        courses.add(
          CourseDto(
            courseId: '${_getInt(courseData, 'id')}',
            clazzId: '${_getInt(content, 'id')}',
            cpi: '${_getInt(channel, 'cpi')}',
            image: '${courseData['imageurl'] ?? ''}',
            name: '${courseData['name'] ?? '未知课程'}',
            teacher: '${courseData['teacherfactor'] ?? ''}',
            state: isActive,
          ),
        );
      }
      return courses;
    } catch (e) {
      debugPrint('获取课程列表异常: $e');
      return [];
    }
  }

  Map<String, dynamic>? _extractCourseData(Map content) {
    final course = content['course'];
    if (course is Map) {
      final dataList = course['data'];
      if (dataList is List && dataList.isNotEmpty && dataList[0] is Map) {
        return Map<String, dynamic>.from(dataList[0] as Map);
      }
    }
    return null;
  }

  int _getInt(Map data, String key) {
    final val = data[key];
    if (val is int) return val;
    if (val is String) return int.tryParse(val) ?? 0;
    return 0;
  }

  Future<List<ActiveDto>> getActivities(
    String courseId,
    String classId,
    String cpi,
  ) async {
    try {
      final joinClassTime = await _getJoinClassTime(courseId, classId, cpi);
      debugPrint('加入课程时间: $joinClassTime');

      final results = await Future.wait([
        _getTaskActivityList(courseId, classId, cpi, joinClassTime),
        _getTaskActivityListWeb(courseId, classId),
      ]);

      final taskData = results[0];
      final webTaskData = results[1];

      debugPrint('移动端活动数据: ${taskData?['activeList']?.length ?? 0} 个');
      debugPrint(
        'Web端活动数据: ${(webTaskData?['data'] as Map?)?['activeList']?.length ?? 0} 个',
      );

      if (taskData == null || webTaskData == null) {
        debugPrint('活动列表数据为空');
        return [];
      }

      final activeList = taskData['activeList'] as List<dynamic>? ?? [];
      final webActiveList =
          (webTaskData['data'] as Map?)?['activeList'] as List<dynamic>? ?? [];

      final activeMap = {
        for (var item in webActiveList)
          if (item is Map) item['id'].toString(): item as Map<String, dynamic>,
      };

      final dtos = <ActiveDto>[];
      for (var activeData in activeList) {
        if (activeData is! Map<String, dynamic>) continue;
        final dto = ActiveDto.fromJson(activeData);
        final activeId = activeData['id'].toString();

        if (activeMap.containsKey(activeId)) {
          final webItem = activeMap[activeId]!;
          if (dto.status && dto.description.isEmpty) {
            dtos.add(
              dto.copyWith(description: webItem['nameFour']?.toString() ?? ''),
            );
            continue;
          }
        }
        dtos.add(dto);
      }

      debugPrint('合并后活动列表: ${dtos.length} 个');
      return dtos;
    } catch (e) {
      debugPrint('获取活动列表异常: $e');
      return [];
    }
  }

  Future<String> _getJoinClassTime(
    String courseId,
    String classId,
    String cpi,
  ) async {
    try {
      const url = 'https://mooc1-api.chaoxing.com/gas/clazzperson';
      final response = await _client.sendRequest(
        url,
        params: {
          'courseid': courseId,
          'clazzid': classId,
          'personid': cpi,
          'view': 'json',
          'fields': 'clazzid,popupagreement,personid,clazzname,createtime',
        },
      );
      final data = response.data;
      if (data is Map &&
          data['data'] is List &&
          (data['data'] as List).isNotEmpty) {
        return (data['data'] as List)[0]['createtime']?.toString() ?? '';
      }
    } catch (e) {
      debugPrint('获取加入课程时间异常: $e');
    }
    return '';
  }

  Future<Map<String, dynamic>?> _getTaskActivityList(
    String courseId,
    String classId,
    String cpi,
    String joinClassTime,
  ) async {
    try {
      const url =
          'https://mobilelearn.chaoxing.com/ppt/activeAPI/taskactivelist';
      final params = {
        'courseId': courseId,
        'classId': classId,
        'cpi': cpi,
        'joinclasstime': joinClassTime,
      };
      final encParams = _encryption.getEncParams(params);
      final allParams = {...params, ...encParams};
      final response = await _client.sendRequest(url, params: allParams);
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('获取移动端活动列表异常: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getTaskActivityListWeb(
    String courseId,
    String classId,
  ) async {
    try {
      const url =
          'https://mobilelearn.chaoxing.com/v2/apis/active/student/activelist';
      final timeStampMS = DateTime.now().millisecondsSinceEpoch.toString();
      final response = await _client.sendRequest(
        url,
        params: {
          'fid': '0',
          'courseId': courseId,
          'classId': classId,
          'showNotStartedActive': '0',
          '_': timeStampMS,
        },
      );
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('获取Web端活动列表异常: $e');
      return null;
    }
  }

  Future<List<HomeworkDto>> getHomeworkList(
    String courseId,
    String classId,
    String cpi,
  ) async {
    try {
      String enc = '';
      String workEnc = '';
      String t = DateTime.now().millisecondsSinceEpoch.toString();

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
            headers: {
              'User-Agent': _browserUa,
              'Referer': referer,
              'Accept': 'text/html,application/xhtml+xml',
              'Accept-Language': 'zh-CN,zh;q=0.9',
            },
          ),
        );

        final statusCode = response.statusCode;
        if (statusCode == 302 ||
            statusCode == 301 ||
            statusCode == 303 ||
            statusCode == 307 ||
            statusCode == 308) {
          String location = (response.headers['location']?.firstOrNull ?? '');
          if (location.contains('login') || location.contains('passport'))
            return [];
          if (location.startsWith('/')) {
            final baseUri = Uri.parse(currentUrl);
            location = '${baseUri.scheme}://${baseUri.host}$location';
          } else if (!location.startsWith('http')) {
            final baseUri = Uri.parse(currentUrl);
            final lastSlash = baseUri.path.lastIndexOf('/');
            if (lastSlash > 0) {
              location =
                  '${baseUri.scheme}://${baseUri.host}${baseUri.path.substring(0, lastSlash + 1)}$location';
            }
          }
          referer = currentUrl;
          currentUrl = location;
          continue;
        }

        if (statusCode == 200 && response.data is String) {
          final html = response.data as String;

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
            final urlEncMatch = RegExp(r'[?&]enc=([^&]+)').firstMatch(html);
            final urlTMatch = RegExp(r'[?&]t=(\d+)').firstMatch(html);
            enc = urlEncMatch?.group(1) ?? '';
            t = urlTMatch?.group(1) ?? t;
            workEnc = enc;
          }

          if (html.contains('无权限') || html.contains('login')) return [];
          break;
        }
        break;
      }

      if (enc.isEmpty) return [];

      final listUrl =
          'https://mooc1.chaoxing.com/mooc2/work/list?courseId=$courseId&classId=$classId&cpi=$cpi&ut=s&t=$t&stuenc=$enc&enc=$workEnc';

      for (int retry = 0; retry < 2; retry++) {
        final response = await _client.sendRequest(
          listUrl,
          options: Options(
            responseType: ResponseType.plain,
            followRedirects: false,
            validateStatus: (status) => status != null && status < 400,
            headers: {'User-Agent': _browserUa},
          ),
        );

        if (response.statusCode == 200 && response.data is String) {
          final html = response.data as String;
          if (html.contains('登录') ||
              html.contains('login') ||
              html.contains('passport'))
            return [];
          if (html.contains('无权限')) return [];
          return _parseWorkList(html, courseId, classId, cpi);
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
        String encVal = '';
        String answerId = '';
        final workIdMatch = RegExp(r'workId=([^&]+)').firstMatch(taskUrl);
        if (workIdMatch != null) workId = workIdMatch.group(1) ?? '';
        final encMatch = RegExp(r'enc=([^&]+)').firstMatch(taskUrl);
        if (encMatch != null) encVal = encMatch.group(1) ?? '';
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
            enc: encVal,
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
