import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color palette
  static const Color primaryPurple = Color(0xFF667EEA);
  static const Color secondaryPurple = Color(0xFF764BA2);
  
  // Theme accent colors
  static const Color forestGreen = Color(0xFF4CAF50);
  static const Color christmasRed = Color(0xFFF44336);
  static const Color campfireOrange = Color(0xFFFF9800);
  static const Color cityBlue = Color(0xFF2196F3);
  
  // Neutral colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2A2A3E);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1A1A2E);

  // Convert hex color string to Color
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPurple,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.interTextTheme(),
    scaffoldBackgroundColor: backgroundLight,

    // ✅ هنا التعديل: CardThemeData بدل CardTheme
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: cardLight,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPurple,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    scaffoldBackgroundColor: backgroundDark,

    // ✅ نفس التعديل هنا
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: cardDark,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
  );

  // Gradient backgrounds
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, secondaryPurple],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundDark, Color(0xFF16213E)],
  );
}
