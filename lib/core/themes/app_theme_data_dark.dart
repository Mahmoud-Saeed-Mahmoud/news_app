import 'package:flutter/material.dart';

class AppThemeDataDark {
  static final ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF66347F),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
