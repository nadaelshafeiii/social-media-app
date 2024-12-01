import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color.fromARGB(255, 245, 245, 245), 
    primary: Color.fromARGB(255, 66, 133, 244), 
    secondary: Color.fromARGB(255, 19, 154, 211), 
    tertiary: Color.fromARGB(255, 1, 9, 14),
    inversePrimary: Color.fromARGB(255, 26, 35, 126), 
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250), 
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.grey.shade800), 
    bodyMedium: TextStyle(color: Colors.grey.shade700), 
    titleLarge: const TextStyle(
      color: Color.fromARGB(255, 66, 133, 244), 
      fontWeight: FontWeight.bold,
    ),
  ),
);
