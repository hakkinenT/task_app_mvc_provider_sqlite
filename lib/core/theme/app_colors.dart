import 'package:flutter/material.dart';

class AppColor {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color error;
  final Color onError;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;

  const AppColor(
      {required this.primary,
      required this.onPrimary,
      required this.secondary,
      required this.onSecondary,
      required this.error,
      required this.onError,
      required this.background,
      required this.onBackground,
      required this.surface,
      required this.onSurface});
}

class AppColorPalette {
  static final Color _background = Color.alphaBlend(
      const Color.fromRGBO(160, 64, 191, 0.08), const Color(0xFF121212));

  static final Color _primary = Color.alphaBlend(
      const Color.fromRGBO(160, 64, 191, 0.15), const Color(0xFF121212));

  static AppColor darkColors = AppColor(
      primary: _primary,
      onPrimary: const Color.fromRGBO(255, 255, 255, 0.87),
      secondary: const Color(0xFFce93d8),
      onSecondary: Colors.black,
      error: const Color(0xFFB53232),
      onError: Colors.black,
      background: _background,
      onBackground: const Color.fromRGBO(255, 255, 255, 0.87),
      surface: _primary,
      onSurface: const Color.fromRGBO(255, 255, 255, 0.87));

  static const successColorLight = Color(0xFF2DF133);
  static final successColorDark = Colors.green.shade200;
}
