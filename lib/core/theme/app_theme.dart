import 'package:flutter/material.dart';

import 'app_colors.dart';

class TaskThemeData {
  static final darkTheme = AppThemeData.themeData(
    colorScheme: darkColorScheme,
    textTheme: ThemeData.dark().textTheme,
  );

  static ColorScheme darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColorPalette.darkColors.primary,
      onPrimary: AppColorPalette.darkColors.onPrimary,
      secondary: AppColorPalette.darkColors.secondary,
      onSecondary: AppColorPalette.darkColors.onSecondary,
      error: AppColorPalette.darkColors.error,
      onError: AppColorPalette.darkColors.onError,
      background: AppColorPalette.darkColors.background,
      onBackground: AppColorPalette.darkColors.onBackground,
      surface: AppColorPalette.darkColors.surface,
      onSurface: AppColorPalette.darkColors.onSurface);
}

class AppThemeData {
  static ThemeData themeData({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) =>
      ThemeData(
          colorScheme: colorScheme,
          scaffoldBackgroundColor: colorScheme.background,
          textSelectionTheme: getTextSelectionThemeData(colorScheme),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: getElevatedButtonStyle(colorScheme)),
          switchTheme: getSwitchThemeData(colorScheme),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: getOutlinedButtonStyle(colorScheme)),
          textButtonTheme:
              TextButtonThemeData(style: getTextButtonStyle(colorScheme)),
          inputDecorationTheme: getInputDecorationTheme(colorScheme),
          appBarTheme: getAppBarTheme(colorScheme),
          iconTheme: getIconThemeData(colorScheme),
          canvasColor: colorScheme.background,
          textTheme: getTextTheme(textTheme),
          progressIndicatorTheme: getProgressIndicatorThemeData(colorScheme),
          cardTheme: getCardTheme(colorScheme),
          snackBarTheme: getSnackBarThemeData(colorScheme),
          checkboxTheme: getCheckboxThemeData(colorScheme),
          timePickerTheme: getTimePickerTheme(colorScheme));

  static ProgressIndicatorThemeData getProgressIndicatorThemeData(
          ColorScheme colorScheme) =>
      ProgressIndicatorThemeData(color: colorScheme.secondary);

  static SnackBarThemeData getSnackBarThemeData(ColorScheme colorScheme) =>
      SnackBarThemeData(
        backgroundColor: AppColorPalette.successColorDark,
        contentTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
      );

  static CardTheme getCardTheme(ColorScheme colorScheme) => CardTheme(
      margin: const EdgeInsets.only(
        left: 0,
        right: 0,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.onPrimary.withOpacity(0.1)),
        borderRadius: const BorderRadius.all(Radius.zero),
      ));

  static ListTileThemeData getListTileThemeData(ColorScheme colorScheme) =>
      ListTileThemeData(
        iconColor: colorScheme.secondary,
      );

  static TextSelectionThemeData getTextSelectionThemeData(
          ColorScheme colorScheme) =>
      TextSelectionThemeData(
          cursorColor: colorScheme.secondary,
          selectionColor: colorScheme.secondary.withOpacity(0.3),
          selectionHandleColor: colorScheme.secondary.withOpacity(0.8));

  static IconThemeData getIconThemeData(ColorScheme colorScheme) =>
      IconThemeData(color: colorScheme.onPrimary);

  static AppBarTheme getAppBarTheme(ColorScheme colorScheme) => AppBarTheme(
      backgroundColor: colorScheme.primary,
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      elevation: 1);

  static ButtonStyle getElevatedButtonStyle(ColorScheme colorScheme) =>
      ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)));

  static TextTheme getTextTheme(TextTheme base) {
    return base.copyWith(
        button: base.button!.copyWith(
            letterSpacing: 2, fontWeight: FontWeight.w500, fontSize: 16));
  }

  static ButtonStyle getOutlinedButtonStyle(ColorScheme colorScheme) =>
      OutlinedButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          side: BorderSide(color: colorScheme.secondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ));

  static ButtonStyle getTextButtonStyle(ColorScheme colorScheme) =>
      TextButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          textStyle: const TextStyle(letterSpacing: 0, fontSize: 14));

  static InputDecorationTheme getInputDecorationTheme(
          ColorScheme colorScheme) =>
      InputDecorationTheme(
          focusColor: colorScheme.secondary.withOpacity(0.5),
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.all(16),
          hintStyle: TextStyle(color: colorScheme.onPrimary.withOpacity(0.5)),
          labelStyle: TextStyle(fontSize: 16, color: colorScheme.secondary),
          suffixIconColor: colorScheme.secondary,
          filled: true,
          fillColor: colorScheme.primary.withOpacity(0.84),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: colorScheme.secondary)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(color: colorScheme.secondary.withOpacity(0.5))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: colorScheme.secondary)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: colorScheme.error)));

  static CheckboxThemeData getCheckboxThemeData(ColorScheme colorScheme) =>
      CheckboxThemeData(
          side: BorderSide(color: colorScheme.primary, width: 2),
          checkColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }

            return null;
          }),
          fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary;
            }

            return null;
          }));

  static SwitchThemeData getSwitchThemeData(ColorScheme colorScheme) =>
      SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return colorScheme.secondary;
        }

        return null;
      }), trackColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return colorScheme.secondary.withOpacity(0.3);
        }

        return null;
      }));

  static TimePickerThemeData getTimePickerTheme(ColorScheme colorScheme) =>
      TimePickerThemeData(
        backgroundColor: colorScheme.primary,
        dayPeriodColor: colorScheme.secondary,
        dayPeriodTextColor: colorScheme.onPrimary,
        hourMinuteColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? colorScheme.secondary
                : colorScheme.background),
        hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? colorScheme.onSecondary
                : colorScheme.onBackground),
        dialHandColor: colorScheme.secondary,
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
        ),
        dialTextColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? colorScheme.onSecondary
                : colorScheme.onSurface),
        entryModeIconColor: colorScheme.secondary,
      );
}
