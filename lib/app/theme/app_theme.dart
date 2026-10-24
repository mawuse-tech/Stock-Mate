import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: canvas,
  colorScheme: ColorScheme.fromSeed(seedColor: lavender, surface: canvas),
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: canvas,
    foregroundColor: ink,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: AppTextStyles.appBarTitle,
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Color(0xFF9B9DA5)),
  ),
);
