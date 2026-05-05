import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infra/theme/theme_data.dart';
import '../../infra/theme/theme_compiler.dart';
import '../../infra/storage/storage_service.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeData>((ref) {
  return ThemeNotifier();
});

final themeDataNotifierProvider = Provider<ThemeData>((ref) {
  final theme = ref.watch(themeProvider);
  return ThemeCompiler.compile(theme);
});

class ThemeNotifier extends StateNotifier<AppThemeData> {
  ThemeNotifier() : super(AppThemeData.defaultTheme) {
    _loadTheme();
  }

  static const String _themeKey = 'selected_theme_id';
  static const String _customBgKey = 'custom_backgrounds';

  Map<String, Map<String, dynamic>> get customBackgrounds => _customBackgrounds;
  Map<String, Map<String, dynamic>> _customBackgrounds = {};

  Future<void> _loadTheme() async {
    try {
      final storage = SharedPreferencesStorage.instance;
      final themeId = storage.getStringSync(_themeKey);
      if (themeId != null) {
        state = _getThemeById(themeId);
      }
      final customBgJson = storage.getStringSync(_customBgKey);
      if (customBgJson != null) {
        _customBackgrounds = Map<String, Map<String, dynamic>>.from(
          jsonDecode(customBgJson),
        );
        state = state.copyWith(backgrounds: _customBackgrounds);
      }
    } catch (e) {
      debugPrint('加载主题失败: $e');
    }
  }

  Future<void> setTheme(String themeId) async {
    final newTheme = _getThemeById(themeId);
    state = newTheme.copyWith(backgrounds: _customBackgrounds);
    try {
      final storage = SharedPreferencesStorage.instance;
      await storage.setString(_themeKey, themeId);
    } catch (e) {
      debugPrint('保存主题失败: $e');
    }
  }

  AppThemeData _getThemeById(String themeId) {
    switch (themeId) {
      case 'default':
        return AppThemeData.defaultTheme;
      case 'dark':
        return AppThemeData.darkTheme;
      case 'blue_gradient':
        return _blueGradientTheme;
      case 'purple_gradient':
        return _purpleGradientTheme;
      case 'green_gradient':
        return _greenGradientTheme;
      case 'sunset_gradient':
        return _sunsetGradientTheme;
      case 'ocean_gradient':
        return _oceanGradientTheme;
      case 'pink_gradient':
        return _pinkGradientTheme;
      default:
        return AppThemeData.defaultTheme;
    }
  }

  static final _blueGradientTheme = AppThemeData(
    id: 'blue_gradient',
    name: '蓝色渐变',
    description: '清新蓝色渐变背景',
    isBuiltin: true,
    colors: ColorConfig(
      seedColor: const Color(0xFF667eea),
      primaryColor: const Color(0xFF667eea),
      surfaceColor: const Color(0xFFF5F7FA),
    ),
  );

  static final _purpleGradientTheme = AppThemeData(
    id: 'purple_gradient',
    name: '紫色梦幻',
    description: '梦幻紫色渐变背景',
    isBuiltin: true,
    colors: ColorConfig(
      seedColor: const Color(0xFFa855f7),
      primaryColor: const Color(0xFFa855f7),
      surfaceColor: const Color(0xFFF8F6FF),
    ),
  );

  static final _greenGradientTheme = AppThemeData(
    id: 'green_gradient',
    name: '绿色清新',
    description: '清新绿色渐变背景',
    isBuiltin: true,
    colors: ColorConfig(
      seedColor: const Color(0xFF11998e),
      primaryColor: const Color(0xFF11998e),
      surfaceColor: const Color(0xFFF0FFF4),
    ),
  );

  static final _sunsetGradientTheme = AppThemeData(
    id: 'sunset_gradient',
    name: '日落黄昏',
    description: '温暖日落橙渐变背景',
    isBuiltin: true,
    colors: ColorConfig(
      seedColor: const Color(0xFFfa709a),
      primaryColor: const Color(0xFFfa709a),
      surfaceColor: const Color(0xFFFFF5F5),
    ),
  );

  static final _oceanGradientTheme = AppThemeData(
    id: 'ocean_gradient',
    name: '深海蓝',
    description: '深海蓝色渐变背景',
    isBuiltin: true,
    colors: ColorConfig(
      seedColor: const Color(0xFF2193b0),
      primaryColor: const Color(0xFF2193b0),
      surfaceColor: const Color(0xFFF0F9FF),
    ),
  );

  static final _pinkGradientTheme = AppThemeData(
    id: 'pink_gradient',
    name: '粉色浪漫',
    description: '浪漫粉色渐变背景',
    isBuiltin: true,
    colors: ColorConfig(
      seedColor: const Color(0xFFee9ca7),
      primaryColor: const Color(0xFFee9ca7),
      surfaceColor: const Color(0xFFFFF5F7),
    ),
  );

  List<AppThemeData> getAvailableThemes() {
    return [
      AppThemeData.defaultTheme,
      AppThemeData.darkTheme,
      _blueGradientTheme,
      _purpleGradientTheme,
      _greenGradientTheme,
      _sunsetGradientTheme,
      _oceanGradientTheme,
      _pinkGradientTheme,
    ];
  }

  Future<void> setCustomBackground(
    String pageKey,
    Map<String, dynamic> config,
  ) async {
    _customBackgrounds[pageKey] = config;
    state = state.copyWith(backgrounds: _customBackgrounds);
    await _saveCustomBackgrounds();
  }

  Future<void> setCustomColorBackground(String pageKey, Color color) async {
    _customBackgrounds[pageKey] = {
      'type': 'custom_color',
      'color':
          '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
    };
    state = state.copyWith(backgrounds: _customBackgrounds);
    await _saveCustomBackgrounds();
  }

  Future<void> setImageBackground(
    String pageKey,
    String imagePath, {
    double opacity = 1.0,
    String fit = 'cover',
    String alignment = 'center',
  }) async {
    _customBackgrounds[pageKey] = {
      'type': 'image',
      'imagePath': imagePath,
      'opacity': opacity,
      'fit': fit,
      'alignment': alignment,
    };
    state = state.copyWith(backgrounds: _customBackgrounds);
    await _saveCustomBackgrounds();
  }

  Future<void> clearCustomBackground(String pageKey) async {
    _customBackgrounds.remove(pageKey);
    state = state.copyWith(backgrounds: _customBackgrounds);
    try {
      final storage = SharedPreferencesStorage.instance;
      await storage.setString(_customBgKey, jsonEncode(_customBackgrounds));
    } catch (e) {
      debugPrint('清除自定义背景失败: $e');
    }
  }

  Future<void> _saveCustomBackgrounds() async {
    try {
      final storage = SharedPreferencesStorage.instance;
      await storage.setString(_customBgKey, jsonEncode(_customBackgrounds));
    } catch (e) {
      debugPrint('保存自定义背景失败: $e');
    }
  }
}
