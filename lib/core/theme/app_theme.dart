import 'package:flutter/material.dart';

/// 🎨 Brand colors
const Color kPrimaryBlue = Color(0xFF4EACE9);
const Color kSecondaryBlue = Color(0xFF0071CE);
const Color kBgWhite = Color(0xFFFFFFFF);

/// ✏️ Text colors
const Color kTextPrimary = Color(0xFF323232); // Main text (black-ish)
const Color kTextSecondary = Color(0xFF707070); // Secondary text (gray)
const Color kTextTertiary = Color(0xFF979797); // Tertiary text (light gray)

const Color kIconState = Color(0xFF8A96A3); // Icon default state color

const Color KBorderColor = Color(0xFFF0F0F0); //




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
  onBackground: kTextPrimary,

  surface: Colors.white,
  onSurface: kTextPrimary,
  surfaceVariant: Color(0xFFF4F4F4),
  onSurfaceVariant: kTextSecondary,

  outline: kTextTertiary,
);

/// 📱 ThemeData
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightScheme,
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: kBgWhite,
  textTheme: TextTheme(
    displayLarge: TextStyle(color: kTextPrimary),
    displayMedium: TextStyle(color: kTextPrimary),
    displaySmall: TextStyle(color: kTextPrimary),
    headlineLarge: TextStyle(color: kTextPrimary),
    headlineMedium: TextStyle(color: kTextPrimary),
    headlineSmall: TextStyle(color: kTextPrimary),
    titleLarge: TextStyle(color: kTextPrimary),
    titleMedium: TextStyle(color: kTextPrimary),
    titleSmall: TextStyle(color: kTextPrimary),
    bodyLarge: TextStyle(color: kTextSecondary),
    bodyMedium: TextStyle(color: kTextSecondary),
    bodySmall: TextStyle(color: kTextTertiary),
    labelLarge: TextStyle(color: kTextSecondary),
    labelMedium: TextStyle(color: kTextTertiary),
    labelSmall: TextStyle(color: kTextTertiary),
  ),
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
