import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

ThemeData light({Color color = const Color(0xFF7ED321)}) => ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: color,
  secondaryHeaderColor: const Color(0xFF5BB819),
  disabledColor: const Color(0xFF9CA3AF),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9CA3AF),
  cardColor: const Color(0xFFFFFFFF),
  scaffoldBackgroundColor: const Color(0xFFF5F7F8),
  shadowColor: Colors.black.withValues(alpha: 0.04),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
  colorScheme: ColorScheme.light(primary: color, secondary: color).copyWith(
      surface: const Color(0xFFF5F7F8)).copyWith(error: const Color(0xFFDC2626),
      surfaceBright: const Color(0xFFEFF4F1)),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFFFFFFFF), surfaceTintColor: Color(0xFFFFFFFF)),
  dialogTheme: const DialogThemeData(surfaceTintColor: Color(0xFFFFFFFF)),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)),
      backgroundColor: const Color(0xFF7ED321),
      foregroundColor: Colors.white),
  bottomAppBarTheme: const BottomAppBarThemeData(
    surfaceTintColor: Color(0xFFFFFFFF), height: 64,
    padding: EdgeInsets.symmetric(vertical: 8),
  ),
  dividerTheme: const DividerThemeData(thickness: 0.5, color: Color(0xFFE5E7EB)),
  tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
);
