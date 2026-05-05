import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../infra/network/dio_client.dart';
import '../../../models/todo_dto.dart';

class CXTodoApi {
  final AppDioClient _client;

  CXTodoApi(this._client);

  Future<Map<String, dynamic>?> getTodoList() async {
    try {
      const url = 'https://todo.chaoxing.com/interface/synchrodata/pushtodo';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: jsonEncode({}),
        headers: {'Content-Type': 'application/json'},
      );
      return response.data;
    } catch (e) {
      debugPrint('getTodoList error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> pushTodo(Map<String, dynamic> data) async {
    try {
      const url = 'https://todo.chaoxing.com/interface/synchrodata/pushtodo';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      return response.data;
    } catch (e) {
      debugPrint('pushTodo error: $e');
      return null;
    }
  }

  Future<TodoDto?> addTodo({
    required String title,
    String content = '',
    String courseid = '',
    String endtime = '',
    int remind = 0,
    int remindtype = 0,
  }) async {
    try {
      const url = 'https://todo.chaoxing.com/interface/todo/addtodo';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: jsonEncode({
          'title': title,
          'content': content,
          'courseid': courseid,
          'endtime': endtime,
          'remind': remind,
          'remindtype': remindtype,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return TodoDto.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('addTodo error: $e');
      return null;
    }
  }

  Future<bool?> deleteTodo({required String todoId}) async {
    try {
      const url = 'https://todo.chaoxing.com/interface/todo/deltodo';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: jsonEncode({'id': todoId}),
        headers: {'Content-Type': 'application/json'},
      );
      return response.data?['result'] == 1;
    } catch (e) {
      debugPrint('deleteTodo error: $e');
      return null;
    }
  }

  Future<bool?> completeTodo({required String todoId}) async {
    try {
      const url = 'https://todo.chaoxing.com/interface/todo/completetodo';
      final response = await _client.sendRequest(
        url,
        method: 'POST',
        body: jsonEncode({'id': todoId}),
        headers: {'Content-Type': 'application/json'},
      );
      return response.data?['result'] == 1;
    } catch (e) {
      debugPrint('completeTodo error: $e');
      return null;
    }
  }
}
