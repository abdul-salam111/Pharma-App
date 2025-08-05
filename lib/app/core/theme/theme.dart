import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.appLightThemeBackground,
    brightness: Brightness.light,
    primaryColor: AppColors.appPrimaryColor,
    cardColor: AppColors.appLightThemeBackground,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.blue,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appPrimaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.roboto(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: GoogleFonts.roboto(fontSize: 18.0, color: Colors.black),
      bodyMedium: GoogleFonts.roboto(fontSize: 16.0, color: Colors.black),
      bodySmall: GoogleFonts.roboto(fontSize: 14.0, color: Colors.black),
      displayLarge: GoogleFonts.roboto(fontSize: 12.0, color: Colors.black),
      displayMedium: GoogleFonts.roboto(fontSize: 10.0, color: Colors.black),
      displaySmall: GoogleFonts.roboto(fontSize: 8.0, color: Colors.black),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.appDarkThemeBackground,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.grey,
    ),
    brightness: Brightness.dark,
    primaryColor: AppColors.appPrimaryColor,
    cardColor: AppColors.appDarkThemeBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appPrimaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.roboto(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.roboto(fontSize: 18.0, color: Colors.white70),
      bodyMedium: GoogleFonts.roboto(fontSize: 16.0, color: Colors.white70),
      bodySmall: GoogleFonts.roboto(fontSize: 14.0, color: Colors.white70),
      displayLarge: GoogleFonts.roboto(fontSize: 12.0, color: Colors.white70),
      displayMedium: GoogleFonts.roboto(fontSize: 10.0, color: Colors.white70),
      displaySmall: GoogleFonts.roboto(fontSize: 8.0, color: Colors.white70),
    ),
  );
}
