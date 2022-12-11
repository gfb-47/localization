import 'package:flutter/material.dart';

class LocThemeData {
  LocThemeData();
  static ThemeData data = ThemeData(
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromRGBO(196, 196, 196, 0.83),
    ),
    textTheme: const TextTheme(
      titleSmall: TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
    ),
  );
}
