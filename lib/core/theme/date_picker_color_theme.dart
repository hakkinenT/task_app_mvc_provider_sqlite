import 'package:flutter/material.dart';

class PickerTheme {
  static ThemeData _pickerTheme(
      {required ColorScheme colorScheme,
      TextButtonThemeData? textButtonThemeData,
      Color? dialogBackgroundColor}) {
    return ThemeData().copyWith(
        colorScheme: colorScheme,
        textButtonTheme: textButtonThemeData,
        dialogBackgroundColor: dialogBackgroundColor);
  }

  static ThemeData datePickerTheme(BuildContext context) {
    final actualSecondaryColor = Theme.of(context).colorScheme.secondary;
    final actualPrimaryColor = Theme.of(context).colorScheme.primary;

    final colorScheme = Theme.of(context)
        .colorScheme
        .copyWith(primary: actualSecondaryColor, onPrimary: actualPrimaryColor);

    return _pickerTheme(
        colorScheme: colorScheme, dialogBackgroundColor: actualPrimaryColor);
  }
}
