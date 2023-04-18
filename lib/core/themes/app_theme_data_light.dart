import 'package:flutter/material.dart';

class AppThemeDataLight {
  static final ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFA7727D),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );
}
