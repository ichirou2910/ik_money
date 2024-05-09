import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = const Color(0xff1f1f1f);
  static Color lightAccent = const Color(0xff2ca8e2);
  static Color darkAccent = const Color(0xff2ca8e2);
  static Color lightBG = Colors.white;
  static Color darkBG = const Color(0xff121212);

  static Color darkBlue = const Color(0xFF1E1E2C);
  static Color lightBlue = const Color(0xFF2D2D44);

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeConfig.lightBlue,
    brightness: Brightness.light,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeConfig.darkBlue,
    brightness: Brightness.dark,
  );
}
