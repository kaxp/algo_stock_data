import 'package:algo_test/config/themes/assets/app_colors.dart';
import 'package:flutter/material.dart';

mixin AppTheme {
  static final defaultTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    primaryColor: AppColors.white,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    textTheme: ThemeData.light().textTheme.copyWith(
          bodyLarge: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontFamily: 'Poppins',
            height: 1.4,
            color: Colors.black,
          ),
          displayLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.normal,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
          displayMedium: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          displaySmall: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          headlineLarge: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
          titleLarge: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          labelLarge: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        fontFamily: 'Poppins',
        color: Colors.white,
      ),
      backgroundColor: AppColors.backgroundColor,
      foregroundColor: AppColors.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    iconTheme: IconThemeData(
      color: Colors.grey[600],
    ),
    cardTheme: CardTheme(
      shadowColor: Colors.grey[200],
      color: AppColors.white,
      margin: EdgeInsets.zero,
      elevation: 6.0,
    ),
    buttonTheme: const ButtonThemeData(
      height: 56,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
    ),
  );
}
