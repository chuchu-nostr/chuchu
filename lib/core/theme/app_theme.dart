import 'package:flutter/material.dart';

const Color kPrimaryPink   = Color(0xFFFF7EB3);
const Color kBgCream       = Color(0xFFFFF8FB);
const Color kAccentPurple  = Color(0xFF7E57C2);

/// 2️⃣ Light ColorScheme
final ColorScheme lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: kPrimaryPink,
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFFFC2D8),
  onPrimaryContainer: Color(0xFF520021),

  secondary: kAccentPurple,
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFD9CCF7),
  onSecondaryContainer: Color(0xFF26005D),

  tertiary: Color(0xFFFFBBD0),
  onTertiary: Colors.black,

  error: Color(0xFFBA1A1A),
  onError: Colors.white,

  background: kBgCream,
  onBackground: Color(0xFF1F1F1F),

  surface: Colors.white,
  onSurface: Color(0xFF1F1F1F),
  surfaceVariant: Color(0xFFF4EAF0),
  onSurfaceVariant: Color(0xFF52474E),

  outline: Color(0xFF85737A),
);

/// 3️⃣ Dark ColorScheme
final ColorScheme darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: kPrimaryPink,
  onPrimary: Color(0xFF520021),
  primaryContainer: Color(0xFF5A0030),
  onPrimaryContainer: Color(0xFFFFC2D8),

  secondary: kAccentPurple,
  onSecondary: Color(0xFFD9CCF7),
  secondaryContainer: Color(0xFF4B3890),
  onSecondaryContainer: Color(0xFFE6DEFF),

  tertiary: Color(0xFF713C85),
  onTertiary: Colors.white,

  error: Color(0xFFCF6679),
  onError: Colors.black,

  background: Color(0xFF1D1B1E),
  onBackground: Colors.white,

  surface: Color(0xFF121217),
  onSurface: Colors.white,
  surfaceVariant: Color(0xFF4A464C),
  onSurfaceVariant: Color(0xFFE3D7DE),

  outline: Color(0xFF9D94A1),
);


final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightScheme,
  fontFamily: 'Poppins',
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkScheme,
  fontFamily: 'Poppins',
);

