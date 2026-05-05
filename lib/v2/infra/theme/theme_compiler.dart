import 'package:flutter/material.dart';
import 'theme_data.dart';
import 'theme_extensions.dart';

class ThemeCompiler {
  static double _parseFontSize(
    Map<String, dynamic> fontSizeMap,
    String key,
    double defaultValue,
  ) {
    final value = fontSizeMap[key];
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static ThemeData compile(AppThemeData theme, {ThemeData? fallback}) {
    final brightness = theme.colors.isDark ? Brightness.dark : Brightness.light;
    final seedColor = theme.colors.seedColor;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      primary: theme.colors.primaryColor,
      secondary:
          theme.colors.secondaryColor ?? seedColor.withValues(alpha: 0.7),
      surface: theme.colors.surfaceColor,
      error: theme.colors.errorColor,
    );
    final borderRadius = theme.shapes.borderRadius;
    final cardElevation = theme.shapes.cardElevation;
    final fontSize = theme.typography.fontSize;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: theme.typography.fontFamily.isEmpty
          ? null
          : theme.typography.fontFamily,
      extensions: [
        ThemeBackgrounds(theme.backgrounds),
        ThemeIcons(theme.icons),
        ThemeChat(theme.chat),
        ThemeOpacity(theme.opacity),
      ],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colors.textPrimaryColor,
      ),
      cardTheme: CardThemeData(
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: _parseFontSize(fontSize, 'large', 32.0),
          fontWeight: FontWeight.w500,
          color: theme.colors.textPrimaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: _parseFontSize(fontSize, 'medium', 16.0),
          fontWeight: FontWeight.w500,
          color: theme.colors.textPrimaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: _parseFontSize(fontSize, 'body', 14.0),
          color: theme.colors.textSecondaryColor,
        ),
        bodySmall: TextStyle(
          fontSize: _parseFontSize(fontSize, 'small', 12.0),
          color: theme.colors.textTertiaryColor,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: theme.colors.dividerColor,
        thickness: 1,
      ),
    );
  }
}
