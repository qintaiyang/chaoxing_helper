import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/enums.dart';
import '../storage/storage_service.dart';

part 'platform_service.g.dart';

@riverpod
class PlatformController extends _$PlatformController {
  static const _platformKey = 'current_platform';
  static const _serverKey = 'current_server';

  @override
  PlatformType build() {
    final storage = SharedPreferencesStorage.instance;
    final saved = storage.getStringSync(_platformKey);
    if (saved == 'rainClassroom') return PlatformType.rainClassroom;
    return PlatformType.chaoxing;
  }

  RainClassroomServerType _currentServer = RainClassroomServerType.yuketang;

  RainClassroomServerType get currentServer => _currentServer;

  bool get isChaoxing => state == PlatformType.chaoxing;
  bool get isRainClassroom => state == PlatformType.rainClassroom;

  String get currentPlatformName =>
      state == PlatformType.chaoxing ? 'chaoxing' : 'rainClassroom';

  String get serverName {
    switch (_currentServer) {
      case RainClassroomServerType.yuketang:
        return 'yuketang';
      case RainClassroomServerType.pro:
        return 'pro';
      case RainClassroomServerType.changjiang:
        return 'changjiang';
      case RainClassroomServerType.huanghe:
        return 'huanghe';
    }
  }

  Future<void> setPlatform(PlatformType platform) async {
    if (state == platform) return;
    state = platform;
    final storage = SharedPreferencesStorage.instance;
    await storage.setString(_platformKey, currentPlatformName);
  }

  Future<void> setServer(RainClassroomServerType server) async {
    if (_currentServer == server) return;
    _currentServer = server;
    final storage = SharedPreferencesStorage.instance;
    await storage.setString(_serverKey, serverName);
  }
}
