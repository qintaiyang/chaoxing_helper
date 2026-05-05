import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final ApiExceptionType type;
  final dynamic originalError;

  const ApiException({
    required this.message,
    this.statusCode,
    this.type = ApiExceptionType.unknown,
    this.originalError,
  });

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: '请求超时',
          statusCode: e.response?.statusCode,
          type: ApiExceptionType.timeout,
          originalError: e,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: '网络连接失败',
          statusCode: e.response?.statusCode,
          type: ApiExceptionType.network,
          originalError: e,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        return ApiException(
          message: _messageForStatus(statusCode),
          statusCode: statusCode,
          type: ApiExceptionType.badResponse,
          originalError: e,
        );
      default:
        return ApiException(
          message: e.message ?? '未知网络错误',
          statusCode: e.response?.statusCode,
          type: ApiExceptionType.unknown,
          originalError: e,
        );
    }
  }

  static String _messageForStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权，请重新登录';
      case 403:
        return '拒绝访问';
      case 404:
        return '请求资源不存在';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务不可用';
      default:
        return '请求失败 ($statusCode)';
    }
  }

  @override
  String toString() =>
      'ApiException: $message (statusCode: $statusCode, type: $type)';
}

enum ApiExceptionType { timeout, network, badResponse, auth, business, unknown }
