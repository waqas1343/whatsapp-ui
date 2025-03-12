import 'package:flutter/material.dart';
import '../color_utils/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.appBackground,
      fontFamily: "Montserrat",
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          color: AppColors.blackTextClr,
        ),
        displayMedium: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w800,
          color: AppColors.blackTextClr,
        ),
        displaySmall: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          color: AppColors.blackTextClr,
        ),

        headlineLarge: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: AppColors.blackTextClr,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
          color: AppColors.blackTextClr,
        ),
        headlineSmall: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),

        titleLarge: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
        ),
        titleMedium: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: AppColors.textColorGrey,
        ),
        titleSmall: const TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackTextClr,
        ),

        bodyLarge: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackTextClr,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),
        bodySmall: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),

        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
        ),
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
        labelSmall: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackTextClr,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color.fromARGB(255, 39, 34, 51),
      fontFamily: "Montserrat",
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          color: AppColors.whiteTextClr,
        ),
        displayMedium: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w800,
          color: AppColors.whiteTextClr,
        ),
        displaySmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          color: AppColors.whiteTextClr,
        ),

        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: AppColors.whiteTextClr,
        ),
        headlineMedium: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
          color: AppColors.whiteTextClr,
        ),
        headlineSmall: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: AppColors.whiteTextClr,
        ),

        titleLarge: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: AppColors.whiteTextClr,
        ),
        titleMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: AppColors.whiteTextClr,
        ),
        titleSmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: AppColors.whiteTextClr,
        ),

        bodyLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: AppColors.whiteTextClr,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: AppColors.whiteTextClr,
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: AppColors.whiteTextClr,
        ),

        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: AppColors.whiteTextClr,
        ),
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: AppColors.whiteTextClr,
        ),
        labelSmall: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w700,
          color: AppColors.appBackground,
        ),
      ),
    );
  }
}
