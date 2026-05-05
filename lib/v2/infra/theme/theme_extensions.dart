import 'dart:io';
import 'package:flutter/material.dart';

class ThemeBackgrounds extends ThemeExtension<ThemeBackgrounds> {
  final Map<String, dynamic> backgrounds;

  ThemeBackgrounds(this.backgrounds);

  @override
  ThemeBackgrounds copyWith({Map<String, dynamic>? backgrounds}) {
    return ThemeBackgrounds(backgrounds ?? this.backgrounds);
  }

  @override
  ThemeBackgrounds lerp(ThemeBackgrounds? other, double t) => this;

  Map<String, dynamic>? getPageBackground(String pageKey) {
    final bg = backgrounds[pageKey];
    if (bg is Map<String, dynamic>) return bg;
    return null;
  }

  Decoration? getGradientDecoration(String pageKey) {
    return getBackgroundDecoration(pageKey);
  }

  /// 返回页面背景的完整配置（不构建 Decoration）
  Map<String, dynamic>? getPageBackgroundConfig(String pageKey) {
    return backgrounds[pageKey] as Map<String, dynamic>?;
  }

  /// 构建背景 Decoration（支持 gradient/solid/image/custom_color）
  Decoration? getBackgroundDecoration(String pageKey) {
    final config = backgrounds[pageKey] as Map<String, dynamic>?;
    if (config == null) return null;
    final type = config['type'] as String?;
    switch (type) {
      case 'gradient':
        return _buildGradientDecoration(config);
      case 'solid':
        return _buildSolidDecoration(config);
      case 'custom_color':
        return _buildCustomColorDecoration(config);
      case 'image':
        return _buildImageDecoration(config);
      case 'pattern':
        return _buildPatternDecoration(config);
      default:
        return null;
    }
  }

  Decoration? _buildGradientDecoration(Map<String, dynamic> config) {
    final colors = (config['colors'] as List?)
        ?.map((c) => _parseColor(c as String))
        .toList();
    if (colors == null || colors.isEmpty) return null;
    final beginList = config['begin'] as List?;
    final endList = config['end'] as List?;
    final begin = beginList != null && beginList.length == 2
        ? Alignment(beginList[0].toDouble(), beginList[1].toDouble())
        : Alignment.topLeft;
    final end = endList != null && endList.length == 2
        ? Alignment(endList[0].toDouble(), endList[1].toDouble())
        : Alignment.bottomRight;
    return BoxDecoration(
      gradient: LinearGradient(colors: colors, begin: begin, end: end),
    );
  }

  Decoration? _buildSolidDecoration(Map<String, dynamic> config) {
    final colors = (config['colors'] as List?)
        ?.map((c) => _parseColor(c as String))
        .toList();
    if (colors == null || colors.isEmpty) return null;
    return BoxDecoration(color: colors.first);
  }

  Decoration? _buildCustomColorDecoration(Map<String, dynamic> config) {
    final colorStr = config['color'] as String?;
    if (colorStr == null) return null;
    return BoxDecoration(color: _parseColor(colorStr));
  }

  Decoration? _buildImageDecoration(Map<String, dynamic> config) {
    final imagePath =
        config['imagePath'] as String? ?? config['image'] as String?;
    if (imagePath == null || imagePath.isEmpty) return null;
    final file = File(imagePath);
    if (!file.existsSync()) return null;

    final opacity = (config['opacity'] as num?)?.toDouble() ?? 1.0;
    final fit = _parseBoxFit(config['fit'] as String? ?? 'cover');
    final alignment = _parseAlignment(
      config['alignment'] as String? ?? 'center',
    );

    return BoxDecoration(
      image: DecorationImage(
        image: FileImage(file),
        fit: fit,
        alignment: alignment,
        opacity: opacity,
      ),
    );
  }

  Decoration? _buildPatternDecoration(Map<String, dynamic> config) {
    final color = config['color'] as String?;
    if (color == null) return null;
    return BoxDecoration(
      color: _parseColor(color),
      backgroundBlendMode: BlendMode.multiply,
    );
  }

  double getHeaderHeight(String pageKey) {
    final config = backgrounds[pageKey];
    if (config == null) return 180.0;
    return (config['height'] as num?)?.toDouble() ?? 180.0;
  }

  static Color _parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  BoxFit _parseBoxFit(String value) {
    switch (value) {
      case 'contain':
        return BoxFit.contain;
      case 'fill':
        return BoxFit.fill;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  Alignment _parseAlignment(String value) {
    switch (value) {
      case 'topLeft':
        return Alignment.topLeft;
      case 'topCenter':
        return Alignment.topCenter;
      case 'topRight':
        return Alignment.topRight;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'bottomRight':
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }
}

class ThemeIcons extends ThemeExtension<ThemeIcons> {
  final Map<String, dynamic> icons;

  ThemeIcons(this.icons);

  @override
  ThemeIcons copyWith({Map<String, dynamic>? icons}) =>
      ThemeIcons(icons ?? this.icons);

  @override
  ThemeIcons lerp(ThemeIcons? other, double t) => this;

  Map<String, dynamic>? getFileTypeIcon(String fileType) {
    final fileTypes = icons['fileTypes'];
    return fileTypes?[fileType];
  }

  Map<String, dynamic>? getFileIconByExtension(String extension) {
    final fileTypes = icons['fileTypes'];
    if (fileTypes == null) return null;
    final ext = extension.toLowerCase();
    switch (ext) {
      case 'pdf':
        return fileTypes['pdf'];
      case 'doc':
      case 'docx':
        return fileTypes['doc'];
      case 'ppt':
      case 'pptx':
        return fileTypes['ppt'];
      case 'xls':
      case 'xlsx':
        return fileTypes['xls'];
      case 'zip':
      case 'rar':
      case '7z':
        return fileTypes['zip'];
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return fileTypes['image'];
      case 'mp3':
      case 'wav':
      case 'flac':
      case 'aac':
        return fileTypes['audio'];
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'mkv':
        return fileTypes['video'];
      default:
        return fileTypes['default'];
    }
  }

  Map<String, dynamic>? getCourseTypeIcon(String courseType) {
    final courseTypes = icons['courseTypes'];
    return courseTypes?[courseType];
  }

  Map<String, dynamic>? getNavIcon(String navKey) {
    final navIcons = icons['navIcons'];
    return navIcons?[navKey];
  }

  Color? getNavActiveColor(String navKey) {
    final navIcon = getNavIcon(navKey);
    if (navIcon == null) return null;
    final colorStr = navIcon['active'] as String?;
    if (colorStr == null) return null;
    return _parseColor(colorStr);
  }

  static Color _parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}

class ThemeChat extends ThemeExtension<ThemeChat> {
  final Map<String, dynamic> chatConfig;

  ThemeChat(this.chatConfig);

  @override
  ThemeChat copyWith({Map<String, dynamic>? chatConfig}) =>
      ThemeChat(chatConfig ?? this.chatConfig);

  @override
  ThemeChat lerp(ThemeChat? other, double t) => this;

  Color getSelfBubbleColor() {
    final bubble = chatConfig['bubble'] as Map<String, dynamic>?;
    final self = bubble?['self'] as Map<String, dynamic>?;
    return _parseColor(self?['background'] as String? ?? '#4A80F0');
  }

  Color getOtherBubbleColor() {
    final bubble = chatConfig['bubble'] as Map<String, dynamic>?;
    final other = bubble?['other'] as Map<String, dynamic>?;
    return _parseColor(other?['background'] as String? ?? '#FFFFFF');
  }

  Color getSelfTextColor() {
    final bubble = chatConfig['bubble'] as Map<String, dynamic>?;
    final self = bubble?['self'] as Map<String, dynamic>?;
    return _parseColor(self?['textColor'] as String? ?? '#FFFFFF');
  }

  Color getOtherTextColor() {
    final bubble = chatConfig['bubble'] as Map<String, dynamic>?;
    final other = bubble?['other'] as Map<String, dynamic>?;
    return _parseColor(other?['textColor'] as String? ?? '#1D2129');
  }

  double getBubbleRadius() {
    final bubble = chatConfig['bubble'] as Map<String, dynamic>?;
    final self = bubble?['self'] as Map<String, dynamic>?;
    return (self?['borderRadius'] as num?)?.toDouble() ?? 16.0;
  }

  static Color _parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}

class ThemeOpacity extends ThemeExtension<ThemeOpacity> {
  final Map<String, dynamic> opacityConfig;

  ThemeOpacity(this.opacityConfig);

  @override
  ThemeOpacity copyWith({Map<String, dynamic>? opacityConfig}) =>
      ThemeOpacity(opacityConfig ?? this.opacityConfig);

  @override
  ThemeOpacity lerp(ThemeOpacity? other, double t) => this;

  double getOpacity(String componentKey, {double defaultOpacity = 1.0}) {
    final value = opacityConfig[componentKey];
    if (value == null) return defaultOpacity;
    if (value is num) return value.toDouble().clamp(0.0, 1.0);
    return defaultOpacity;
  }

  double getCourseCardOpacity() =>
      getOpacity('courseCard', defaultOpacity: 0.95);
  double getGroupCardOpacity() => getOpacity('groupCard', defaultOpacity: 0.95);
  double getPanCardOpacity() => getOpacity('panCard', defaultOpacity: 0.95);
  double getAccountCardOpacity() =>
      getOpacity('accountCard', defaultOpacity: 0.95);
  double getInboxCardOpacity() => getOpacity('inboxCard', defaultOpacity: 0.95);
  double getBottomNavBarOpacity() =>
      getOpacity('bottomNavBar', defaultOpacity: 1.0);
}
