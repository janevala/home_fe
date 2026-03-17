import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _AdaptMobile {
  static const double textScaleFactor = 0.9;
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  static const EdgeInsets listTilePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 0);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(Radi.small));
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(Radi.small));
  static const BorderRadius inputBorderRadius = BorderRadius.all(Radius.circular(Radi.small));
  static const BorderRadius dialogBorderRadius = BorderRadius.all(Radius.circular(Radi.small));
  static const BorderRadius drawerBorderRadius = BorderRadius.only(
    topRight: Radius.circular(Radi.medium),
    bottomRight: Radius.circular(Radi.medium),
  );
  static const double dialogElevation = 6.0;
}

class Radi {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
}

class AppColors {
  static const Color linkBlue = Color(0xFF1976D2);
}

class AppTheme {
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1976D2),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE3F2FD),
    onPrimaryContainer: Color(0xFF0D47A1),
    secondary: Color(0xFF455A64),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFECEFF1),
    onSecondaryContainer: Color(0xFF263238),
    tertiary: Color(0xFF00796B),
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
    primary: Color(0xFF90CAF9),
    onPrimary: Color(0xFF0D47A1),
    primaryContainer: Color(0xFF1565C0),
    onPrimaryContainer: Color(0xFFE3F2FD),
    secondary: Color(0xFFB0BEC5),
    onSecondary: Color(0xFF263238),
    secondaryContainer: Color(0xFF37474F),
    onSecondaryContainer: Color(0xFFECEFF1),
    tertiary: Color(0xFF4DB6AC),
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

  static ThemeData getThemeForPlatform({required bool isDarkMode}) {
    ThemeData baseTheme;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      baseTheme = isDarkMode ? cupertinoDarkTheme : cupertinoLightTheme;
    } else {
      baseTheme = isDarkMode ? darkTheme : lightTheme;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
      return _applyMobileAdjustments(baseTheme, isDarkMode);
    }

    return baseTheme;
  }

  static TextTheme _adaptForMobile(TextTheme baseTheme) {
    return baseTheme.copyWith(
      titleLarge: baseTheme.titleLarge?.copyWith(
        fontSize: (baseTheme.titleLarge?.fontSize ?? 20) * _AdaptMobile.textScaleFactor,
      ),
      bodyLarge: baseTheme.bodyLarge?.copyWith(
        fontSize: (baseTheme.bodyLarge?.fontSize ?? 16) * _AdaptMobile.textScaleFactor,
      ),
      bodyMedium: baseTheme.bodyMedium?.copyWith(
        fontSize: (baseTheme.bodyMedium?.fontSize ?? 14) * _AdaptMobile.textScaleFactor,
      ),
      labelLarge: baseTheme.labelLarge?.copyWith(
        fontSize: (baseTheme.labelLarge?.fontSize ?? 14) * _AdaptMobile.textScaleFactor,
      ),
    );
  }

  static ThemeData _applyMobileAdjustments(ThemeData baseTheme, bool isDarkMode) {
    return baseTheme.copyWith(
      textTheme: _adaptForMobile(baseTheme.textTheme),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        titleTextStyle: baseTheme.appBarTheme.titleTextStyle?.copyWith(
          fontSize: (baseTheme.appBarTheme.titleTextStyle?.fontSize ?? 20) * _AdaptMobile.textScaleFactor,
        ),
        toolbarHeight: 48.0,
      ),
      cardTheme: baseTheme.cardTheme.copyWith(
        margin: _AdaptMobile.cardMargin,
        shape: RoundedRectangleBorder(borderRadius: _AdaptMobile.cardBorderRadius),
      ),
      listTileTheme: baseTheme.listTileTheme.copyWith(
        contentPadding: _AdaptMobile.listTilePadding,
        titleTextStyle: baseTheme.textTheme.titleMedium?.copyWith(
          fontSize: (baseTheme.textTheme.titleMedium?.fontSize ?? 16) * _AdaptMobile.textScaleFactor,
        ),
        subtitleTextStyle: baseTheme.textTheme.bodyMedium?.copyWith(
          fontSize: (baseTheme.textTheme.bodyMedium?.fontSize ?? 14) * _AdaptMobile.textScaleFactor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: _AdaptMobile.buttonBorderRadius),
          padding: _AdaptMobile.buttonPadding,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: _AdaptMobile.buttonBorderRadius),
          padding: _AdaptMobile.buttonPadding,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: _AdaptMobile.buttonBorderRadius),
          padding: _AdaptMobile.buttonPadding,
        ),
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        contentPadding: _AdaptMobile.inputPadding,
        border: OutlineInputBorder(borderRadius: _AdaptMobile.inputBorderRadius),
        enabledBorder: OutlineInputBorder(
          borderRadius: _AdaptMobile.inputBorderRadius,
          borderSide: BorderSide(
            color: isDarkMode
                ? baseTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)
                : baseTheme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _AdaptMobile.inputBorderRadius,
          borderSide: BorderSide(color: baseTheme.colorScheme.primary, width: 2),
        ),
      ),
      dialogTheme: baseTheme.dialogTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: _AdaptMobile.dialogBorderRadius,
        ),
        titleTextStyle: baseTheme.textTheme.titleLarge?.copyWith(
          fontSize: (baseTheme.textTheme.titleLarge?.fontSize ?? 20) * _AdaptMobile.textScaleFactor,
        ),
        contentTextStyle: baseTheme.textTheme.bodyLarge?.copyWith(
          fontSize: (baseTheme.textTheme.bodyLarge?.fontSize ?? 16) * _AdaptMobile.textScaleFactor,
        ),
      ),
      drawerTheme: baseTheme.drawerTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: _AdaptMobile.drawerBorderRadius,
        ),
      ),
    );
  }

  static TextTheme get _lightTextTheme {
    return TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: _lightColorScheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _lightColorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _lightColorScheme.onSurface,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _lightColorScheme.onSurface,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 2,
        scrolledUnderElevation: 4,
        titleTextStyle: _lightTextTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radi.medium)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightColorScheme.primary,
          foregroundColor: _lightColorScheme.onPrimary,
          elevation: 2,
          shadowColor: _lightColorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radi.medium)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: _lightColorScheme.primaryContainer,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _lightColorScheme.surface,
        elevation: _AdaptMobile.dialogElevation,
        shadowColor: _lightColorScheme.shadow.withValues(alpha: 0.2),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: _AdaptMobile.dialogBorderRadius,
        ),
        titleTextStyle: _lightTextTheme.titleLarge?.copyWith(
          color: _lightColorScheme.onSurface,
        ),
        contentTextStyle: _lightTextTheme.bodyLarge?.copyWith(
          color: _lightColorScheme.onSurfaceVariant,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: _lightColorScheme.surface,
        surfaceTintColor: _lightColorScheme.surfaceTint,
        shadowColor: _lightColorScheme.shadow.withValues(alpha: 0.2),
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Radi.large),
            bottomRight: Radius.circular(Radi.large),
          ),
        ),
      ),
      textTheme: _lightTextTheme,
    );
  }

  static TextTheme get _darkTextTheme {
    return TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: _darkColorScheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _darkColorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _darkColorScheme.onSurface,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _darkColorScheme.onSurface,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 2,
        scrolledUnderElevation: 4,
        titleTextStyle: _darkTextTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radi.medium)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkColorScheme.primary,
          foregroundColor: _darkColorScheme.onPrimary,
          elevation: 3,
          shadowColor: _darkColorScheme.shadow.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radi.medium)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: _darkColorScheme.primaryContainer,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _darkColorScheme.surface,
        elevation: _AdaptMobile.dialogElevation,
        shadowColor: _darkColorScheme.shadow.withValues(alpha: 0.4),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: _AdaptMobile.dialogBorderRadius,
        ),
        titleTextStyle: _darkTextTheme.titleLarge?.copyWith(
          color: _darkColorScheme.onSurface,
        ),
        contentTextStyle: _darkTextTheme.bodyLarge?.copyWith(
          color: _darkColorScheme.onSurfaceVariant,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: _darkColorScheme.surface,
        surfaceTintColor: _darkColorScheme.surfaceTint,
        shadowColor: _darkColorScheme.shadow.withValues(alpha: 0.4),
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Radi.large),
            bottomRight: Radius.circular(Radi.large),
          ),
        ),
      ),
      textTheme: _darkTextTheme,
    );
  }

  static TextTheme get _cupertinoLightTextTheme {
    return TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: _lightColorScheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _lightColorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _lightColorScheme.onSurface,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _lightColorScheme.onSurface,
      ),
    );
  }

  static ThemeData get cupertinoLightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _lightColorScheme.primary,
        brightness: Brightness.light,
        surface: _lightColorScheme.surface,
        onSurface: _lightColorScheme.onSurface,
        surfaceContainer: _lightColorScheme.surfaceContainer,
        onSurfaceVariant: _lightColorScheme.onSurfaceVariant,
        primary: _lightColorScheme.primary,
        onPrimary: Colors.white,
        secondary: _lightColorScheme.secondary,
        onSecondary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _lightColorScheme.surface,
        foregroundColor: _lightColorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _cupertinoLightTextTheme.titleLarge,
        iconTheme: IconThemeData(color: _lightColorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: _lightColorScheme.surface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radi.medium),
          side: BorderSide(
            color: _lightColorScheme.onSurface.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightColorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: _lightColorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radi.medium),
          borderSide: BorderSide(
            color: _lightColorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radi.medium),
          borderSide: BorderSide(
            color: _lightColorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radi.medium),
          borderSide: BorderSide(color: _lightColorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: _lightColorScheme.primaryContainer,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _lightColorScheme.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radi.large),
          side: BorderSide(
            color: _lightColorScheme.onSurface.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
        titleTextStyle: _cupertinoLightTextTheme.titleLarge?.copyWith(
          color: _lightColorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: _cupertinoLightTextTheme.bodyLarge?.copyWith(
          color: _lightColorScheme.onSurfaceVariant,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        alignment: Alignment.center,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: _lightColorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(Radi.large),
            bottomRight: Radius.circular(Radi.large),
          ),
          side: BorderSide(
            color: _lightColorScheme.onSurface.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      textTheme: _cupertinoLightTextTheme,
    );
  }

  static TextTheme get _cupertinoDarkTextTheme {
    return TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: _darkColorScheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _darkColorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _darkColorScheme.onSurface,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _darkColorScheme.onSurface,
      ),
    );
  }

  static ThemeData get cupertinoDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _darkColorScheme.primary,
        brightness: Brightness.dark,
        surface: _darkColorScheme.surface,
        onSurface: _darkColorScheme.onSurface,
        surfaceContainer: _darkColorScheme.surfaceContainer,
        onSurfaceVariant: _darkColorScheme.onSurfaceVariant,
        primary: _darkColorScheme.primary,
        onPrimary: Colors.white,
        secondary: _darkColorScheme.secondary,
        onSecondary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _darkColorScheme.surface,
        foregroundColor: _darkColorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _cupertinoDarkTextTheme.titleLarge,
        iconTheme: IconThemeData(color: _darkColorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: _darkColorScheme.surface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radi.medium),
          side: BorderSide(
            color: _darkColorScheme.onSurfaceVariant.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkColorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radi.medium)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radi.medium),
          borderSide: BorderSide(
            color: _darkColorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radi.medium),
          borderSide: BorderSide(
            color: _darkColorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radi.medium),
          borderSide: BorderSide(color: _darkColorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: _darkColorScheme.primaryContainer,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _darkColorScheme.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radi.large),
          side: BorderSide(
            color: _darkColorScheme.onSurfaceVariant.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        titleTextStyle: _cupertinoDarkTextTheme.titleLarge?.copyWith(
          color: _darkColorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: _cupertinoDarkTextTheme.bodyLarge?.copyWith(
          color: _darkColorScheme.onSurfaceVariant,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        alignment: Alignment.center,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: _darkColorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(Radi.large),
            bottomRight: Radius.circular(Radi.large),
          ),
          side: BorderSide(
            color: _darkColorScheme.onSurfaceVariant.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      textTheme: _cupertinoDarkTextTheme,
    );
  }
}
