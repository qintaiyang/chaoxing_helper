import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infra/storage/storage_service.dart';
import 'icon_splash_providers.dart';

final customIconAndSplashProvider =
    StateNotifierProvider<CustomIconAndSplashNotifier, CustomIconAndSplashState>(
  (ref) {
    return CustomIconAndSplashNotifier(ref);
  },
);

class CustomIconAndSplashState {
  final String? customIconPath;
  final String? customSplashPath;
  final int currentIconIndex;
  final int maxIconSlots;

  const CustomIconAndSplashState({
    this.customIconPath,
    this.customSplashPath,
    this.currentIconIndex = 0,
    this.maxIconSlots = 3,
  });

  CustomIconAndSplashState copyWith({
    String? customIconPath,
    String? customSplashPath,
    int? currentIconIndex,
  }) {
    return CustomIconAndSplashState(
      customIconPath: customIconPath ?? this.customIconPath,
      customSplashPath: customSplashPath ?? this.customSplashPath,
      currentIconIndex: currentIconIndex ?? this.currentIconIndex,
    );
  }

  bool get isCustomIcon => currentIconIndex == 1;
}

class CustomIconAndSplashNotifier
    extends StateNotifier<CustomIconAndSplashState> {
  CustomIconAndSplashNotifier(this._ref)
      : super(const CustomIconAndSplashState()) {
    _loadCustomAssets();
  }

  final Ref _ref;
  static const String _iconKey = 'custom_icon_path';
  static const String _splashKey = 'custom_splash_path';

  Future<void> _loadCustomAssets() async {
    try {
      final storage = SharedPreferencesStorage.instance;
      final iconPath = storage.getStringSync(_iconKey);
      final splashPath = storage.getStringSync(_splashKey);

      final iconIndexResult =
          await _ref.read(getCurrentIconIndexUseCaseProvider).execute();
      final currentIndex = iconIndexResult.getOrElse((_) => 0);

      state = CustomIconAndSplashState(
        customIconPath: iconPath,
        customSplashPath: splashPath,
        currentIconIndex: currentIndex,
      );
    } catch (e) {
      debugPrint('加载自定义图标和启动图失败: $e');
    }
  }

  Future<void> setCustomIcon(String iconPath) async {
    state = state.copyWith(customIconPath: iconPath);
    try {
      final storage = SharedPreferencesStorage.instance;
      await storage.setString(_iconKey, iconPath);
    } catch (e) {
      debugPrint('保存自定义图标失败: $e');
    }
  }

  Future<void> setCustomSplash(String splashPath) async {
    state = state.copyWith(customSplashPath: splashPath);
    try {
      final storage = SharedPreferencesStorage.instance;
      await storage.setString(_splashKey, splashPath);

      final updateResult =
          await _ref.read(updateSplashImageUseCaseProvider).execute(splashPath);
      updateResult.fold(
        (failure) => debugPrint('更新原生启动图失败: $failure'),
        (_) {},
      );
    } catch (e) {
      debugPrint('保存自定义启动图失败: $e');
    }
  }

  Future<void> resetCustomIcon() async {
    state = state.copyWith(customIconPath: null, currentIconIndex: 0);
    try {
      final storage = SharedPreferencesStorage.instance;
      await storage.remove(_iconKey);

      final switchResult =
          await _ref.read(switchIconUseCaseProvider).execute(0);
      switchResult.fold(
        (failure) => debugPrint('恢复默认图标失败: $failure'),
        (_) {},
      );
    } catch (e) {
      debugPrint('恢复默认图标失败: $e');
    }
  }

  Future<void> resetCustomSplash() async {
    state = state.copyWith(customSplashPath: null);
    try {
      final storage = SharedPreferencesStorage.instance;
      await storage.remove(_splashKey);
    } catch (e) {
      debugPrint('重置自定义启动图失败: $e');
    }
  }

  Future<bool> applyAndSwitchIcon(int targetIndex) async {
    if (targetIndex > 0 && state.customIconPath == null) {
      debugPrint('自定义图标槽位需要先选择图片');
      return false;
    }

    try {
      final result = await _ref.read(applyIconToSlotUseCaseProvider).execute(
            iconPath: state.customIconPath ?? '',
            iconIndex: targetIndex,
          );

      return result.fold(
        (failure) {
          debugPrint('切换图标失败: $failure');
          return false;
        },
        (success) {
          if (success) {
            state = state.copyWith(currentIconIndex: targetIndex);
          }
          return success;
        },
      );
    } catch (e) {
      debugPrint('切换图标失败: $e');
      return false;
    }
  }

  Future<String?> changeIcon() async {
    try {
      final result = await _ref.read(pickAndSaveIconUseCaseProvider).execute();
      return result.fold(
        (failure) {
          debugPrint('更改图标失败: $failure');
          return null;
        },
        (iconPath) {
          state = state.copyWith(customIconPath: iconPath);
          return iconPath;
        },
      );
    } catch (e) {
      debugPrint('更改图标失败: $e');
      return null;
    }
  }

  Future<String?> changeSplash() async {
    try {
      final result =
          await _ref.read(pickAndSaveSplashImageUseCaseProvider).execute();
      return result.fold(
        (failure) {
          debugPrint('更改启动图失败: $failure');
          return null;
        },
        (splashPath) {
          state = state.copyWith(customSplashPath: splashPath);
          return splashPath;
        },
      );
    } catch (e) {
      debugPrint('更改启动图失败: $e');
      return null;
    }
  }
}
