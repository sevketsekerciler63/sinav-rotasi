import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Visual language for Sınav Rotası: an ink-and-paper atlas with mint routes,
/// lime checkpoints, and warm amber exam markers.
class AppTheme {
  // Map canvas and raised surfaces.
  static const Color primaryDark = Color(0xFF0D1B20);
  static const Color surfaceDark = Color(0xFF14272D);
  static const Color cardDark = Color(0xFF1B3338);
  static const Color cardDarkAlt = Color(0xFF203A3E);
  static const Color borderDark = Color(0xFF304A4E);

  // Paper mode keeps the map identity in a softer, warmer palette.
  static const Color primaryLight = Color(0xFFF4F1E8);
  static const Color surfaceLight = Color(0xFFFFFDF7);
  static const Color cardLight = Color(0xFFFFFEFA);
  static const Color cardLightAlt = Color(0xFFEAEDE4);
  static const Color borderLight = Color(0xFFD4D9CF);

  // Named by their existing API roles; the palette now follows one route map.
  static const Color accentBlue = Color(0xFF64D7C0); // route mint
  static const Color accentPurple = Color(0xFFB7A6D8); // study note
  static const Color accentGreen = Color(0xFFC5DE78); // waypoint lime
  static const Color accentOrange = Color(0xFFE3A63C); // exam marker
  static const Color accentRed = Color(0xFFFF8275); // attention marker
  static const Color accentCyan = Color(0xFF80C9DC); // alternate route
  static const Color accentPink = Color(0xFFE7A5B2);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF19413F), Color(0xFF28604F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF276D58), Color(0xFF3E9270)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFF9A6423), Color(0xFFBD8533)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFF984A4A), Color(0xFFB55D53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF176F70), Color(0xFF268E87)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient getSubjectGradient(String subjectName) {
    if (subjectName.contains('Matematik')) {
      return const LinearGradient(
        colors: [Color(0xFF385B4B), Color(0xFF607B4A)],
      );
    }
    if (subjectName.contains('Turkce') || subjectName.contains('Türkçe')) {
      return const LinearGradient(
        colors: [Color(0xFF68484A), Color(0xFF965E52)],
      );
    }
    if (subjectName.contains('Fizik')) {
      return const LinearGradient(
        colors: [Color(0xFF285365), Color(0xFF377486)],
      );
    }
    if (subjectName.contains('Kimya')) {
      return const LinearGradient(
        colors: [Color(0xFF286B69), Color(0xFF34847C)],
      );
    }
    if (subjectName.contains('Biyoloji')) {
      return const LinearGradient(
        colors: [Color(0xFF315D4A), Color(0xFF477B5A)],
      );
    }
    if (subjectName.contains('Sosyal')) {
      return const LinearGradient(
        colors: [Color(0xFF75552E), Color(0xFF9A7139)],
      );
    }
    return primaryGradient;
  }

  static Color getSubjectColor(String subjectName) {
    if (subjectName.contains('Matematik')) return accentGreen;
    if (subjectName.contains('Turkce') || subjectName.contains('Türkçe')) {
      return accentPink;
    }
    if (subjectName.contains('Fizik')) return accentCyan;
    if (subjectName.contains('Kimya')) return accentBlue;
    if (subjectName.contains('Biyoloji')) return const Color(0xFF8CCB91);
    if (subjectName.contains('Sosyal')) return accentOrange;
    return accentBlue;
  }

  static ThemeData get darkTheme {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFF3F4E8),
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFF3F4E8),
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFF3F4E8),
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFF3F4E8),
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFD2DFD9),
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFF3F4E8),
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFB8C9C4),
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF96ADA8),
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: primaryDark,
      primaryColor: accentBlue,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        onPrimary: primaryDark,
        secondary: accentGreen,
        onSecondary: primaryDark,
        surface: surfaceDark,
        onSurface: Color(0xFFF3F4E8),
        error: accentRed,
        onError: primaryDark,
      ),
      dividerColor: borderDark,
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: Color(0xFFD2DFD9)),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderDark, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: const Color(0xFFF3F4E8),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFF3F4E8),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: accentBlue,
        unselectedItemColor: Color(0xFF91A6A1),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: surfaceDark,
        indicatorColor: accentBlue.withValues(alpha: 0.17),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? accentBlue : const Color(0xFF91A6A1),
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: primaryDark,
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: primaryDark,
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentBlue,
          minimumSize: const Size(0, 46),
          side: const BorderSide(color: borderDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: accentBlue,
          minimumSize: const Size(44, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentBlue,
        foregroundColor: primaryDark,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardDarkAlt,
        // Açık etiket yazısı seçili hâlde de okunabilsin (kontrast ≈ 5,5:1).
        selectedColor: const Color(0xFF2F5A4F),
        checkmarkColor: accentBlue,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(0xFFD2DFD9),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: borderDark),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDarkAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accentBlue, width: 1.5),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentBlue,
        linearTrackColor: borderDark,
        circularTrackColor: borderDark,
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData(brightness: Brightness.light, useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF172A2D),
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF172A2D),
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF172A2D),
      ),
      bodyLarge: GoogleFonts.inter(color: const Color(0xFF172A2D)),
      bodyMedium: GoogleFonts.inter(color: const Color(0xFF51645F)),
      bodySmall: GoogleFonts.inter(color: const Color(0xFF657772)),
    );

    return base.copyWith(
      scaffoldBackgroundColor: primaryLight,
      primaryColor: const Color(0xFF006B5B),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF006B5B),
        onPrimary: Colors.white,
        secondary: Color(0xFF627C35),
        onSecondary: Colors.white,
        surface: surfaceLight,
        onSurface: Color(0xFF172A2D),
        error: Color(0xFFBE584F),
        onError: Colors.white,
      ),
      dividerColor: borderLight,
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: Color(0xFF37534E)),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: const Color(0xFF172A2D),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF172A2D),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF37534E)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceLight,
        selectedItemColor: Color(0xFF006B5B),
        unselectedItemColor: Color(0xFF788780),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: surfaceLight,
        indicatorColor: const Color(0xFF006B5B).withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? const Color(0xFF006B5B) : const Color(0xFF788780),
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006B5B),
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF006B5B),
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF006B5B),
          minimumSize: const Size(0, 46),
          side: const BorderSide(color: borderLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF006B5B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: const Color(0xFF006B5B),
          minimumSize: const Size(44, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF006B5B),
        foregroundColor: Colors.white,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardLightAlt,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(0xFF37534E),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: borderLight),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardLightAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF006B5B), width: 1.5),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF006B5B),
        linearTrackColor: borderLight,
        circularTrackColor: borderLight,
      ),
    );
  }
}
