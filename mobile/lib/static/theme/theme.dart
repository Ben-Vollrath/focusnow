import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);
  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xFF4C6ED9),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF4C6ED9),
      onSecondary: Color(0xFF59647A),
      tertiary: Color(0xFF4C6ED9),
      error: Color(0xFFD32F2F), // Default red for errors
      onError: Color(0xFFFFFFFF),
      background: Color(0xFFF8F9FB),
      onBackground: Color(0xFF1A213E),
      surfaceContainerHighest: Color.fromARGB(255, 244, 245, 250),
      surface: Color(0xFFF8F9FB),
      onSurface: Color(0xFF1A213E));
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF97AAFC),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF97AAFC),
      onSecondary: Color(0xFFCDD1D9),
      tertiary: Color(0xFF97AAFC),
      error: Color(0xFFD32F2F), // Default red for errors
      onError: Color(0xFF121B24),
      background: Color(0xFF1F2631),
      onBackground: Color(0xFFFFFFFF),
      surfaceContainerHighest: Color.fromARGB(255, 29, 31, 38),
      surface: Color(0xFF1F2631),
      onSurface: Color(0xFFFFFFFF),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.error,
    required this.onError,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color error;
  final Color onError;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface, 
      brightness: brightness,
      surfaceContainerHighest: surfaceContainerHighest, 
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
