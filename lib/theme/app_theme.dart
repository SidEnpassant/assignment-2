import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Colors.red,
      onPrimary: Colors.white,
      secondary: Colors.red,
      background: Colors.black,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Colors.grey, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
    ),
    fontFamily: 'Poppins',
  );
}
