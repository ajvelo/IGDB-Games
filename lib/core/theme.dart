import 'package:flutter/material.dart';

class GlobalTheme {
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.blue,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
      headlineMedium: TextStyle(
          fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
      headlineSmall: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 18.0, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black),
      bodySmall: TextStyle(fontSize: 14.0, color: Colors.black),
    ),
  );
}
