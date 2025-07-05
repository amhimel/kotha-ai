import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData kothaAITheme = ThemeData(
  brightness: Brightness.dark,
  //scaffoldBackgroundColor: const Color(0xFF0F111A),
  primaryColor: const Color(0xFF00B3FF),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF00B3FF),
    secondary: Color(0xFF5EEAD4),
    error: Color(0xFFFF5252),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.dark().textTheme.copyWith(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Color(0xFFB0BEC5)),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00B3FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
);
