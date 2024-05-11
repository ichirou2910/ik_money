import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = const Color(0xff1f1f1f);
  static Color lightAccent = const Color(0xff2ca8e2);
  static Color darkAccent = const Color(0xff2ca8e2);
  static Color lightBG = Colors.white;
  static Color darkBG = const Color(0xff121212);

  static ThemeData lightTheme = ThemeData(
    primaryColor: lightPrimary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: darkPrimary,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(secondary: darkAccent),
    scaffoldBackgroundColor: darkBG,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
    ),
  );
}
