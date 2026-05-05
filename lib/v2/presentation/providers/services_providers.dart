import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../infra/services/im_service.dart';
import '../../infra/services/notification_service.dart';
import '../../infra/services/push_dispatcher.dart';
import '../../infra/services/dnd_service.dart';
import '../../infra/services/member_name_cache.dart';

part 'services_providers.g.dart';

@Riverpod(keepAlive: true)
GlobalKey<NavigatorState> navigatorKey(NavigatorKeyRef ref) {
  return GlobalKey<NavigatorState>();
}

@Riverpod(keepAlive: true)
ImService imService(ImServiceRef ref) {
  final key = ref.watch(navigatorKeyProvider);
  return ImService(navigatorKey: key);
}

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}

@Riverpod(keepAlive: true)
PushDispatcher pushDispatcher(PushDispatcherRef ref) {
  final key = ref.watch(navigatorKeyProvider);
  return PushDispatcher(navigatorKey: key);
}

@Riverpod(keepAlive: true)
DndService dndService(DndServiceRef ref) {
  return DndService();
}

@Riverpod(keepAlive: true)
MemberNameCache memberNameCache(MemberNameCacheRef ref) {
  return MemberNameCache();
}
