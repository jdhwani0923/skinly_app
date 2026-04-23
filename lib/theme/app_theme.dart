import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // === EXACT STITCH COLORS ===
  static const Color primary = Color(0xFF805062);         // Dusty Rose (active states, CTAs)
  static const Color primaryContainer = Color(0xFFF8BBD0); // Light pink container
  static const Color background = Color(0xFFFBF9F8);      // Warm off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F3F3);
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color secondary = Color(0xFF6B5A60);
  static const Color outline = Color(0xFF827377);
  static const Color outlineVariant = Color(0xFFD4C2C6);

  // Gradient matching the Stitch pink-to-maroon button gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF48FB1), Color(0xFF805062)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get ambientShadow => [
    BoxShadow(
      color: const Color(0xFFF8BBD0).withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        primaryContainer: primaryContainer,
        secondary: secondary,
        surface: surface,
        onSurface: onSurface,
        outline: outline,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.manropeTextTheme().copyWith(
        displayLarge: GoogleFonts.manrope(
          fontSize: 34, fontWeight: FontWeight.w800,
          letterSpacing: -0.5, color: onSurface,
        ),
        headlineLarge: GoogleFonts.manrope(
          fontSize: 28, fontWeight: FontWeight.w700,
          letterSpacing: -0.3, color: onSurface,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 22, fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleLarge: GoogleFonts.manrope(
          fontSize: 18, fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.manrope(
          fontSize: 16, fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 14, fontWeight: FontWeight.w400,
          color: secondary,
        ),
        labelLarge: GoogleFonts.manrope(
          fontSize: 12, fontWeight: FontWeight.w700,
          letterSpacing: 1.2, color: secondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
          textStyle: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryContainer, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: TextStyle(color: secondary.withValues(alpha: 0.5), fontSize: 15),
        labelStyle: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: secondary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20, fontWeight: FontWeight.w700, color: onSurface,
        ),
        iconTheme: const IconThemeData(color: onSurface),
      ),
    );
  }
}
