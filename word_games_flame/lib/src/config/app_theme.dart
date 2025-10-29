import 'package:flutter/material.dart';

enum TileType {
  normal(bgColor: AppTheme.tileBgColor, labelColor: AppTheme.tileLabelColor),
  selected(
      bgColor: AppTheme.tileBgSelectedColor,
      labelColor: AppTheme.tileLabelSelectedColor),
  correct(bgColor: Colors.green, labelColor: AppTheme.tileLabelColor),
  incorrect(bgColor: Colors.black, labelColor: AppTheme.tileLabelColor);

  final Color bgColor;
  final Color labelColor;

  const TileType({required this.bgColor, required this.labelColor});
}

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 135, 135, 135);
  static const Color darkPrimaryColor = Color.fromARGB(255, 40, 39, 41);
  static const Color lightPrimaryColor = Color.fromARGB(255, 186, 186, 186);
  static const Color accentColor = Color(0xFFFF4081);
  static const Color primaryText = Color.fromARGB(255, 135, 135, 135);
  static const Color secondaryText = Color(0xFF757575);
  static const Color textIcons = Color(0xFFFFFFFF);
  static const Color session1Color = Color(0xFFD1C4E9);
  static const Color session2Color = Color(0xFFD1C4E9);
  static const Color session3Color = Color(0xFFD1C4E9);

  static const Color tileLabelColor = Colors.white;
  static const Color tileBgColor = Colors.black;
  static const Color tileLabelSelectedColor = Colors.black;
  static const Color tileBgSelectedColor = Colors.white;

  static TextStyle get baseText => const TextStyle(
        fontFamily: "SimplyRounded",
        color: primaryText,
      );

  static TextStyle tileLabelStyle = const TextStyle(
    color: tileLabelColor,
    fontSize: 24.0,
    decoration: TextDecoration.none,
  );
}
