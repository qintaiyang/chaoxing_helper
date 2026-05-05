import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user_notice.dart';
import '../../app_dependencies.dart';

part 'notice_controller.g.dart';

@riverpod
class UserNoticeListController extends _$UserNoticeListController {
  @override
  Future<List<UserNotice>> build() async {
    final puid = getPuid();
    if (puid == null || puid.isEmpty) {
      throw Exception('未登录');
    }

    try {
      final result = await AppDependencies.instance.getUserNoticesUseCase.call(
        puid: puid,
      );
      return result.fold(
        (failure) => throw Exception(failure.message),
        (notices) => notices,
      );
    } catch (e) {
      debugPrint('UserNoticeListController error: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  String? getPuid() {
    return AppDependencies.instance.accountRepo
        .getCurrentSessionId()
        .fold((l) => null, (r) => r);
  }

  Future<Map<String, dynamic>?> checkNoticeStatus(String puid) async {
    try {
      return await AppDependencies.instance.cxNoticeApi.checkNoticeStatus(
        puid: puid,
      );
    } catch (e) {
      debugPrint('checkNoticeStatus error: $e');
      return null;
    }
  }

  Future<List<UserNotice>> fetchNoticesOnce(String puid, {int maxW = 1000}) async {
    try {
      final rawList = await AppDependencies.instance.cxNoticeApi.syncUserNotices(
        puid: puid,
      );
      return _parseNotices(rawList);
    } catch (e) {
      debugPrint('fetchNoticesOnce error: $e');
      return [];
    }
  }

  List<UserNotice> _parseNotices(List<Map<String, dynamic>> rawList) {
    return rawList
        .map((e) => UserNotice.fromJson(e))
        .toList();
  }
}
