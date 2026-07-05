import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppConstants.primaryColor,
      colorScheme: const ColorScheme.light(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.accentColor,
        surface: AppConstants.lightBg,
        onSurface: AppConstants.lightText,
      ),
      scaffoldBackgroundColor: AppConstants.lightBg,
      cardTheme: CardThemeData(
        color: AppConstants.lightCardBg,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
      textTheme:
          GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
        bodyMedium: GoogleFonts.outfit(color: AppConstants.lightText),
        bodyLarge:
            GoogleFonts.outfit(color: AppConstants.lightText, fontSize: 16),
        titleLarge: GoogleFonts.outfit(
            color: AppConstants.lightText, fontWeight: FontWeight.bold),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.lightBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppConstants.lightText),
        titleTextStyle: TextStyle(
          color: AppConstants.lightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppConstants.primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.accentColor,
        surface: AppConstants.darkBg,
        onSurface: AppConstants.darkText,
      ),
      scaffoldBackgroundColor: AppConstants.darkBg,
      cardTheme: CardThemeData(
        color: AppConstants.darkCardBg,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
      textTheme:
          GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyMedium: GoogleFonts.outfit(color: AppConstants.darkText),
        bodyLarge:
            GoogleFonts.outfit(color: AppConstants.darkText, fontSize: 16),
        titleLarge: GoogleFonts.outfit(
            color: AppConstants.darkText, fontWeight: FontWeight.bold),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppConstants.darkText),
        titleTextStyle: TextStyle(
          color: AppConstants.darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
