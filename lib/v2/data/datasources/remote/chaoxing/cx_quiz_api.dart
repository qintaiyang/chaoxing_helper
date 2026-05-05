import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';

class CXQuizApi {
  final AppDioClient _client;

  CXQuizApi(this._client);

  Future<bool?> checkStatus({
    required String classId,
    required String activeId,
  }) async {
    try {
      const url =
          'https://mobilelearn.chaoxing.com/pptTestPaperStu/checkActiveStatus';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: {
          'classId': classId,
          'activePrimaryId': activeId,
          'appType': '15',
        },
      );
      if (response.data['status'] != null) {
        return response.data['status'] == 1;
      }
      return null;
    } catch (e) {
      debugPrint('checkStatus error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitAnswer({
    required String classId,
    required String courseId,
    required String activeId,
    required String answer,
  }) async {
    try {
      const url =
          'https://mobilelearn.chaoxing.com/v2/apis/studentQuestion/doQuestionAnswering';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        params: {
          'activeId': activeId,
          'courseId': courseId,
          'classId': classId,
          'DB_STRATEGY': 'PRIMARY_KEY',
          'STRATEGY_PARA': 'activeId',
        },
        headers: {'Content-Type': 'application/json'},
        body: answer,
      );
      return response.data;
    } catch (e) {
      debugPrint('submitAnswer error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getQuizDetail({
    required String activeId,
    bool v2 = false,
  }) async {
    try {
      final url = v2
          ? 'https://mobilelearn.chaoxing.com/v2/apis/quiz/quizDetail?activeId=$activeId'
          : 'https://mobilelearn.chaoxing.com/v2/apis/quiz/quizDetail2?activeId=$activeId&moreClassAttendEnc=&DB_STRATEGY=PRIMARY_KEY&STRATEGY_PARA=activeId';
      final response = await _client.sendRequest(url);
      return response.data['data'];
    } catch (e) {
      debugPrint('getQuizDetail error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitVote({
    required String courseId,
    required String classId,
    required String activeId,
    required String questionId,
    required String answer,
  }) async {
    try {
      const url =
          'https://mobilelearn.chaoxing.com/widget/quickvote/doQuestion';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: {
          'courseId': courseId,
          'classId': classId,
          'activeId': activeId,
          'questionId': questionId,
          'option': answer,
        },
      );
      return response.data;
    } catch (e) {
      debugPrint('submitVote error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitQuestionnaire({
    required String courseId,
    required String classId,
    required String activeId,
    required Map<String, List<String>> answers,
  }) async {
    try {
      const url =
          'https://mobilelearn.chaoxing.com/v2/apis/studentQuestion/doQuestion';
      var formData =
          'preventsubmit=1&courseId=$courseId&classId=$classId&activeId=$activeId';
      for (final entry in answers.entries) {
        formData += '&questionId=${entry.key}';
        for (final answer in entry.value) {
          formData += '&answer${entry.key}=$answer';
        }
      }
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: formData,
      );
      return response.data;
    } catch (e) {
      debugPrint('submitQuestionnaire error: $e');
      return null;
    }
  }
}
