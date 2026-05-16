import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

ThemeData buildTheme() {
  final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme().apply(
    bodyColor: AppColors.ink,
    displayColor: AppColors.ink,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.lavender400,
      primary: AppColors.lavender400,
      secondary: AppColors.mint300,
      surface: AppColors.cream,
      onSurface: AppColors.ink,
      brightness: Brightness.light,
    ),
    textTheme: baseTextTheme.copyWith(
      headlineMedium: GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      headlineLarge: GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    ),
    splashFactory: InkRipple.splashFactory,
  );
}

TextStyle displayLarge() => GoogleFonts.fraunces(
  fontSize: 92,
  height: 0.95,
  fontWeight: FontWeight.w600,
  letterSpacing: -2,
  color: AppColors.ink,
);

TextStyle h2() => GoogleFonts.fraunces(
  fontSize: 22,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);
