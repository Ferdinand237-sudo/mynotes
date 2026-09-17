import 'package:flutter/material.dart';

abstract final class AppColors {
  static const blue = Color(0xFF2478F2);
  static const ink = Color(0xFF101B3B);
  static const muted = Color(0xFF65718A);
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
    scaffoldBackgroundColor: const Color(0xFFFAFBFF),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: _border,
      enabledBorder: _border,
    ),
  );

  static final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(color: Color(0xFFD9E0EC)),
  );
}
