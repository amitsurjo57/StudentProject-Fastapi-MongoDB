import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarThemeData(
      backgroundColor: Colors.lightGreen,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      border: OutlineInputBorder(),
      labelStyle: TextStyle(
        color: Colors.lightGreen,
        fontWeight: FontWeight.w500,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightGreen),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightGreen, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightGreen,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        foregroundColor: Colors.white,
      ),
    ),
  );
}
