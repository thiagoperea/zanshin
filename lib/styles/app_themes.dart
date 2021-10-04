import 'package:flutter/material.dart';
import 'package:zanshin/styles/app_colors.dart';

class AppThemes {
  const AppThemes();

  static lightTheme() => ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
      );

  static darkTheme() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        canvasColor: AppColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          background: AppColors.darkBackground,
          primary: AppColors.primary,
          secondary: AppColors.primary,
          onSecondary: Colors.white,
          onPrimary: Colors.white,
        ),
      );
}
