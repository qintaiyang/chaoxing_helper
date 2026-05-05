import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../models/exam_dto.dart';

class CXExamApi {
  final AppDioClient _client;

  CXExamApi(this._client);

  Future<List<ExamDto>> getExamList({
    required String courseId,
    required String classId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      const url = 'https://mooc1-api.chaoxing.com/exam/phone/publish-list';
      final response = await _client.sendRequest(
        url,
        params: {
          'courseId': courseId,
          'classId': classId,
          'page': page.toString(),
          'pageSize': pageSize.toString(),
          'view': 'json',
        },
      );

      final data = response.data;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => ExamDto.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('getExamList error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getExamDetail({
    required String examId,
    required String courseId,
    required String classId,
  }) async {
    try {
      const url = 'https://mooc1-api.chaoxing.com/examApi/examDetail';
      final response = await _client.sendRequest(
        url,
        params: {
          'examId': examId,
          'courseId': courseId,
          'classId': classId,
          'view': 'json',
        },
      );
      return response.data;
    } catch (e) {
      debugPrint('getExamDetail error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getExamPaper({
    required String examId,
    required String courseId,
    required String classId,
  }) async {
    try {
      const url = 'https://mooc1-api.chaoxing.com/examApi/examPaper';
      final response = await _client.sendRequest(
        url,
        params: {
          'examId': examId,
          'courseId': courseId,
          'classId': classId,
          'view': 'json',
        },
      );
      return response.data;
    } catch (e) {
      debugPrint('getExamPaper error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitExamAnswer({
    required String examId,
    required String courseId,
    required String classId,
    required String answers,
    required int duration,
  }) async {
    try {
      const url = 'https://mooc1-api.chaoxing.com/examApi/submitExam';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: {
          'examId': examId,
          'courseId': courseId,
          'classId': classId,
          'answers': answers,
          'duration': duration.toString(),
        },
      );
      return response.data;
    } catch (e) {
      debugPrint('submitExamAnswer error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> startExam({
    required String examId,
    required String courseId,
    required String classId,
  }) async {
    try {
      const url = 'https://mooc1-api.chaoxing.com/examApi/startExam';
      final response = await _client.sendRequest(
        url,
        params: {
          'examId': examId,
          'courseId': courseId,
          'classId': classId,
          'view': 'json',
        },
      );
      return response.data;
    } catch (e) {
      debugPrint('startExam error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getExamResult({
    required String examId,
    required String courseId,
    required String classId,
  }) async {
    try {
      const url = 'https://mooc1-api.chaoxing.com/examApi/examResult';
      final response = await _client.sendRequest(
        url,
        params: {
          'examId': examId,
          'courseId': courseId,
          'classId': classId,
          'view': 'json',
        },
      );
      return response.data;
    } catch (e) {
      debugPrint('getExamResult error: $e');
      return null;
    }
  }
}
