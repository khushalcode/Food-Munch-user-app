import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

ThemeData dark({Color color = const Color(0xFF7ED321)}) => ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: color,
  secondaryHeaderColor: const Color(0xFF5BB819),
  disabledColor: const Color(0xFF9CA3AF),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFB8C2C9),
  cardColor: const Color(0xFF1E2A1F),
  scaffoldBackgroundColor: const Color(0xFF0F1A11),
  shadowColor: Colors.black.withValues(alpha: 0.3),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xFFD1D5DB))),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
  colorScheme: ColorScheme.dark(primary: color, secondary: color).copyWith(surface: const Color(0xFF0F1A11)).copyWith(error: const Color(0xFFDC2626)),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF2A3A2D), surfaceTintColor: Color(0xFF2A3A2D)),
  dialogTheme: const DialogThemeData(surfaceTintColor: Color(0xFF2A3A2D)),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)),
      backgroundColor: const Color(0xFF7ED321),
      foregroundColor: Colors.white),
  bottomAppBarTheme: const BottomAppBarThemeData(
    surfaceTintColor: Color(0xFF1E2A1F), height: 64,
    padding: EdgeInsets.symmetric(vertical: 8),
  ),
  dividerTheme: const DividerThemeData(thickness: 0.5, color: Color(0xFF3D4F3F)),
  tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
);
