import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData whiteBackgroundTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xFF0C58CB), // 你可以替换为喜欢的强调色
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0C58CB),
      onPrimary: Colors.white,
      secondary: Color(0xFFE5E5E5),
      onSecondary: Colors.black,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0.5,
      shadowColor: Color(0xFFEEEEEE),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF0C58CB),
      foregroundColor: Colors.white,
    ),
    dividerColor: Color(0xFFE5E5E5),
    cardColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF222222)),
      bodyMedium: TextStyle(color: Color(0xFF666666)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF333333)),
  );
}
