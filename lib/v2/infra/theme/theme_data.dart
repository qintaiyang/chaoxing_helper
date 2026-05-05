import 'dart:ui' show Color;

class AppThemeData {
  final String id;
  final String name;
  final String? description;
  final String? author;
  final String? version;
  final String? iconPath;
  final bool isBuiltin;
  final ColorConfig colors;
  final TypographyConfig typography;
  final ShapeConfig shapes;
  final Map<String, dynamic> backgrounds;
  final Map<String, dynamic> icons;
  final Map<String, dynamic> chat;
  final Map<String, dynamic> opacity;

  const AppThemeData({
    required this.id,
    required this.name,
    this.description,
    this.author,
    this.version = '1.0.0',
    this.iconPath,
    this.isBuiltin = false,
    this.colors = const ColorConfig.empty(),
    this.typography = const TypographyConfig.empty(),
    this.shapes = const ShapeConfig.empty(),
    this.backgrounds = const {},
    this.icons = const {},
    this.chat = const {},
    this.opacity = const {},
  });

  factory AppThemeData.fromJson(Map<String, dynamic> json) {
    return AppThemeData(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      author: json['author'] as String?,
      version: json['version'] as String? ?? '1.0.0',
      iconPath: json['iconPath'] as String?,
      isBuiltin: json['isBuiltin'] as bool? ?? false,
      colors: ColorConfig.fromJson(
        json['colors'] as Map<String, dynamic>? ?? {},
      ),
      typography: TypographyConfig.fromJson(
        json['typography'] as Map<String, dynamic>? ?? {},
      ),
      shapes: ShapeConfig.fromJson(
        json['shapes'] as Map<String, dynamic>? ?? {},
      ),
      backgrounds: json['backgrounds'] as Map<String, dynamic>? ?? {},
      icons: json['icons'] as Map<String, dynamic>? ?? {},
      chat: json['chat'] as Map<String, dynamic>? ?? {},
      opacity: json['opacity'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'author': author,
      'version': version,
      'iconPath': iconPath,
      'isBuiltin': isBuiltin,
      'colors': colors.toJson(),
      'typography': typography.toJson(),
      'shapes': shapes.toJson(),
      'backgrounds': backgrounds,
      'icons': icons,
      'chat': chat,
      'opacity': opacity,
    };
  }

  AppThemeData copyWith({
    String? id,
    String? name,
    String? description,
    String? author,
    String? version,
    String? iconPath,
    bool? isBuiltin,
    ColorConfig? colors,
    TypographyConfig? typography,
    ShapeConfig? shapes,
    Map<String, dynamic>? backgrounds,
    Map<String, dynamic>? icons,
    Map<String, dynamic>? chat,
    Map<String, dynamic>? opacity,
  }) {
    return AppThemeData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      author: author ?? this.author,
      version: version ?? this.version,
      iconPath: iconPath ?? this.iconPath,
      isBuiltin: isBuiltin ?? this.isBuiltin,
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      shapes: shapes ?? this.shapes,
      backgrounds: backgrounds ?? this.backgrounds,
      icons: icons ?? this.icons,
      chat: chat ?? this.chat,
      opacity: opacity ?? this.opacity,
    );
  }

  static const defaultTheme = AppThemeData(
    id: 'default',
    name: '默认主题',
    isBuiltin: true,
  );
  static const darkTheme = AppThemeData(
    id: 'dark',
    name: '深色主题',
    isBuiltin: true,
  );
}

class ColorConfig {
  final Map<String, dynamic> _raw;

  const ColorConfig._(this._raw);
  const ColorConfig.empty() : _raw = const {};

  ColorConfig({
    Color? seedColor,
    Color? primaryColor,
    Color? secondaryColor,
    Color? surfaceColor,
    Color? errorColor,
    bool? isDark,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? textTertiaryColor,
    Color? dividerColor,
  }) : _raw = {
         if (seedColor != null) 'seedColor': _colorToHex(seedColor),
         if (primaryColor != null) 'primaryColor': _colorToHex(primaryColor),
         if (secondaryColor != null)
           'secondaryColor': _colorToHex(secondaryColor),
         if (surfaceColor != null) 'surfaceColor': _colorToHex(surfaceColor),
         if (errorColor != null) 'errorColor': _colorToHex(errorColor),
         if (isDark != null) 'brightness': isDark ? 'dark' : 'light',
         if (textPrimaryColor != null)
           'textPrimaryColor': _colorToHex(textPrimaryColor),
         if (textSecondaryColor != null)
           'textSecondaryColor': _colorToHex(textSecondaryColor),
         if (textTertiaryColor != null)
           'textTertiaryColor': _colorToHex(textTertiaryColor),
         if (dividerColor != null) 'dividerColor': _colorToHex(dividerColor),
       };

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  static ColorConfig fromJson(Map<String, dynamic> json) => ColorConfig._(json);
  Map<String, dynamic> toJson() => _raw;

  String get seed =>
      _raw['seedColor'] as String? ?? _raw['seed'] as String? ?? '#4A80F0';
  Color get seedColor => _parseColor(seed);
  Color get primaryColor =>
      _parseColor(_raw['primaryColor'] as String? ?? seed);
  Color? get secondaryColor => _raw['secondaryColor'] != null
      ? _parseColor(_raw['secondaryColor'] as String)
      : null;
  Color get surfaceColor => _parseColor(
    _raw['surfaceColor'] as String? ?? (isDark ? '#1E1E1E' : '#FFFFFF'),
  );
  Color get errorColor =>
      _parseColor(_raw['errorColor'] as String? ?? '#FF4D4F');
  bool get isDark => (_raw['brightness'] as String? ?? 'light') == 'dark';
  Color get textPrimaryColor => _parseColor(
    _raw['textPrimaryColor'] as String? ?? (isDark ? '#FFFFFF' : '#1D2129'),
  );
  Color get textSecondaryColor => _parseColor(
    _raw['textSecondaryColor'] as String? ?? (isDark ? '#A0A0A0' : '#4E5969'),
  );
  Color get textTertiaryColor => _parseColor(
    _raw['textTertiaryColor'] as String? ?? (isDark ? '#666666' : '#86909C'),
  );
  Color get dividerColor => _parseColor(
    _raw['dividerColor'] as String? ?? (isDark ? '#333333' : '#F0F0F0'),
  );
  Color get navigationBarColor => _raw['navigationBarColor'] != null
      ? _parseColor(_raw['navigationBarColor'] as String)
      : surfaceColor;
  Color get appBarColor => _raw['appBarColor'] != null
      ? _parseColor(_raw['appBarColor'] as String)
      : surfaceColor;

  static Color _parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}

class TypographyConfig {
  final Map<String, dynamic> _raw;

  const TypographyConfig._(this._raw);
  const TypographyConfig.empty() : _raw = const {};

  static TypographyConfig fromJson(Map<String, dynamic> json) =>
      TypographyConfig._(json);
  Map<String, dynamic> toJson() => _raw;

  String get fontFamily => _raw['fontFamily'] as String? ?? '';
  Map<String, dynamic> get fontSize =>
      _raw['fontSize'] as Map<String, dynamic>? ?? {};
}

class ShapeConfig {
  final Map<String, dynamic> _raw;

  const ShapeConfig._(this._raw);
  const ShapeConfig.empty() : _raw = const {};

  static ShapeConfig fromJson(Map<String, dynamic> json) => ShapeConfig._(json);
  Map<String, dynamic> toJson() => _raw;

  double get borderRadius => (_raw['borderRadius'] as num?)?.toDouble() ?? 12.0;
  double get cardElevation =>
      (_raw['cardElevation'] as num?)?.toDouble() ?? 2.0;
}
