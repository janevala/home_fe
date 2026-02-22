import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getThemeForPlatform({required bool isDarkMode}) {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        (kIsWeb && defaultTargetPlatform == TargetPlatform.macOS)) {
      return isDarkMode ? cupertinoDarkTheme : cupertinoLightTheme;
    }

    return isDarkMode ? darkTheme : lightTheme;
  }

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1976D2), // Blue primary
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE3F2FD),
    onPrimaryContainer: Color(0xFF0D47A1),
    secondary: Color(0xFF455A64), // Blue-grey secondary
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFECEFF1),
    onSecondaryContainer: Color(0xFF263238),
    tertiary: Color(0xFF00796B), // Teal accent
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE0F2F1),
    onTertiaryContainer: Color(0xFF004D40),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFEBEE),
    onErrorContainer: Color(0xFFB71C1C),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF212121),
    surfaceContainer: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF757575),
    inverseSurface: Color(0xFF212121),
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFF90CAF9),
    surfaceTint: Color(0xFF1976D2),
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF90CAF9), // Light blue primary
    onPrimary: Color(0xFF0D47A1),
    primaryContainer: Color(0xFF1565C0),
    onPrimaryContainer: Color(0xFFE3F2FD),
    secondary: Color(0xFFB0BEC5), // Light blue-grey secondary
    onSecondary: Color(0xFF263238),
    secondaryContainer: Color(0xFF37474F),
    onSecondaryContainer: Color(0xFFECEFF1),
    tertiary: Color(0xFF4DB6AC), // Light teal accent
    onTertiary: Color(0xFF004D40),
    tertiaryContainer: Color(0xFF00695C),
    onTertiaryContainer: Color(0xFFE0F2F1),
    error: Color(0xFFEF5350),
    onError: Color(0xFFB71C1C),
    errorContainer: Color(0xFFC62828),
    onErrorContainer: Color(0xFFFFEBEE),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE0E0E0),
    surfaceContainer: Color(0xFF2C2C2C),
    onSurfaceVariant: Color(0xFFB0BEC5),
    outline: Color(0xFF616161),
    outlineVariant: Color(0xFF424242),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE0E0E0),
    onInverseSurface: Color(0xFF121212),
    inversePrimary: Color(0xFF1976D2),
    surfaceTint: Color(0xFF90CAF9),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        scrolledUnderElevation: 4,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        scrolledUnderElevation: 4,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  static const Color _cupertinoLightPrimary = Color(0xFF007AFF);
  static const Color _cupertinoLightSecondary = Color(0xFF5856D6);
  static const Color _cupertinoLightBackground = Color(0xFFF2F2F7);
  static const Color _cupertinoLightSurface = Color(0xFFFFFFFF);
  static const Color _cupertinoLightLabel = Color(0xFF000000);
  static const Color _cupertinoLightSecondaryLabel = Color(0xFF3C3C43);
  static const Color _cupertinoLightTertiaryLabel = Color(0xFF3C3C4399);

  static const Color _cupertinoDarkPrimary = Color(0xFF0A84FF);
  static const Color _cupertinoDarkSecondary = Color(0xFF5E5CE6);
  static const Color _cupertinoDarkBackground = Color(0xFF000000);
  static const Color _cupertinoDarkSurface = Color(0xFF1C1C1E);
  static const Color _cupertinoDarkLabel = Color(0xFFFFFFFF);
  static const Color _cupertinoDarkSecondaryLabel = Color(0xFFEBEBF5);
  static const Color _cupertinoDarkTertiaryLabel = Color(0xFFEBEBF599);

  static ThemeData get cupertinoLightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _cupertinoLightPrimary,
        brightness: Brightness.light,
        surface: _cupertinoLightSurface,
        onSurface: _cupertinoLightLabel,
        surfaceContainer: _cupertinoLightBackground,
        onSurfaceVariant: _cupertinoLightSecondaryLabel,
        primary: _cupertinoLightPrimary,
        onPrimary: Colors.white,
        secondary: _cupertinoLightSecondary,
        onSecondary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _cupertinoLightSurface,
        foregroundColor: _cupertinoLightLabel,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: _cupertinoLightLabel,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: _cupertinoLightLabel),
      ),
      cardTheme: CardThemeData(
        color: _cupertinoLightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: _cupertinoLightTertiaryLabel.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _cupertinoLightPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _cupertinoLightPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _cupertinoLightTertiaryLabel.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _cupertinoLightTertiaryLabel.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _cupertinoLightPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: const TextStyle(
          color: _cupertinoLightLabel,
          fontSize: 17,
        ),
        subtitleTextStyle: TextStyle(
          color: _cupertinoLightSecondaryLabel,
          fontSize: 15,
        ),
      ),
    );
  }

  static ThemeData get cupertinoDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _cupertinoDarkPrimary,
        brightness: Brightness.dark,
        surface: _cupertinoDarkSurface,
        onSurface: _cupertinoDarkLabel,
        surfaceContainer: _cupertinoDarkBackground,
        onSurfaceVariant: _cupertinoDarkSecondaryLabel,
        primary: _cupertinoDarkPrimary,
        onPrimary: Colors.white,
        secondary: _cupertinoDarkSecondary,
        onSecondary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _cupertinoDarkSurface,
        foregroundColor: _cupertinoDarkLabel,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: _cupertinoDarkLabel,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: _cupertinoDarkLabel),
      ),
      cardTheme: CardThemeData(
        color: _cupertinoDarkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: _cupertinoDarkTertiaryLabel.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _cupertinoDarkPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _cupertinoDarkPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _cupertinoDarkTertiaryLabel.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _cupertinoDarkTertiaryLabel.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _cupertinoDarkPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: const TextStyle(
          color: _cupertinoDarkLabel,
          fontSize: 17,
        ),
        subtitleTextStyle: TextStyle(
          color: _cupertinoDarkSecondaryLabel,
          fontSize: 15,
        ),
      ),
    );
  }
}
