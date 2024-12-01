import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  colorScheme:  const ColorScheme.light(
    surface: Colors.transparent, 
    primary: Color.fromARGB(255, 115, 168, 255), 
    secondary: Color.fromARGB(255, 179, 234, 255), 
    tertiary: Color.fromARGB(255, 179, 234, 255),
    inversePrimary: Color.fromARGB(255, 36, 48, 102), 
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 40, 40, 50),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), 
    bodyMedium: TextStyle(color: Color.fromARGB(255, 200, 200, 200)), 
    titleLarge: TextStyle(
      color: Color.fromARGB(255, 115, 168, 255), 
      fontWeight: FontWeight.bold,
    ),
  ),
);
