import 'package:flutter/material.dart';

/// 🎨 Brand colors
const Color kPrimaryBlue = Color(0xFF4EACE9);
const Color kSecondaryBlue = Color(0xFF0071CE);
const Color kBgWhite = Color(0xFFFFFFFF);


final ColorScheme lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: kPrimaryBlue,
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFCFE8F9),
  onPrimaryContainer: Color(0xFF002843),

  secondary: kSecondaryBlue,
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFC2DEFA),
  onSecondaryContainer: Color(0xFF001A33),

  tertiary: Color(0xFFFFB74D),
  onTertiary: Colors.black,

  error: Color(0xFFBA1A1A),
  onError: Colors.white,

  background: kBgWhite,
  onBackground: Color(0xFF1F1F1F),

  surface: Colors.white,
  onSurface: Color(0xFF1F1F1F),
  surfaceVariant: Color(0xFFF4F4F4),
  onSurfaceVariant: Color(0xFF444444),

  outline: Color(0xFFB0B0B0),
);

/// 📱 ThemeData
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightScheme,
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: kBgWhite,
  appBarTheme: const AppBarTheme(
    backgroundColor: kBgWhite,
    foregroundColor: kSecondaryBlue,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
);
