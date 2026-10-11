import 'package:flutter/material.dart';

abstract final class SipenaPalette {
  static const navy = Color(0xFF173B70);
  static const blue = Color(0xFF3478F6);
  static const teal = Color(0xFF20A899);
  static const section = Color(0xFFEDF4FC);
  static const canvas = Color(0xFFF5F8FC);
  static const white = Color(0xFFFFFFFF);
  static const ink = Color(0xFF17324F);
  static const body = Color(0xFF43556D);
  static const muted = Color(0xFF7C8BA0);
  static const line = Color(0xFFE1E8F0);
  static const paleBlue = Color(0xFFE2EDFC);
  static const paleTeal = Color(0xFFE3F5F2);
  static const paleGold = Color(0xFFFFF3D9);
  static const gold = Color(0xFFD59A22);
  static const red = Color(0xFFB74350);
  static const paleRed = Color(0xFFFBEAEC);
  static const softBlue = Color(0xFFF6F9FE);
  static const softTeal = Color(0xFFF2FAF8);
  static const darkCanvas = Color(0xFF101923);
  static const darkSurface = Color(0xFF1B2838);
  static const darkSection = Color(0xFF203750);
}

abstract final class SipenaSpacing {
  static const xs = 6.0;
  static const sm = 12.0;
  static const md = 18.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const pageMobile = 20.0;
  static const pageDesktop = 36.0;
  static const radius = 10.0;
}

abstract final class SipenaTheme {
  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: SipenaPalette.navy,
          surface: SipenaPalette.white,
        ).copyWith(
          primary: SipenaPalette.navy,
          onPrimary: SipenaPalette.white,
          secondary: SipenaPalette.teal,
          onSecondary: SipenaPalette.white,
          surface: SipenaPalette.white,
          onSurface: SipenaPalette.ink,
          error: SipenaPalette.red,
        );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SipenaPalette.canvas,
      canvasColor: SipenaPalette.white,
      cardColor: SipenaPalette.white,
      dividerColor: SipenaPalette.line,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      textTheme: _textTheme(SipenaPalette.ink, SipenaPalette.body),
      appBarTheme: const AppBarTheme(
        backgroundColor: SipenaPalette.canvas,
        foregroundColor: SipenaPalette.navy,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: SipenaPalette.navy,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: _inputTheme(
        fill: const Color(0xFFF8FAFD),
        border: SipenaPalette.line,
        focus: SipenaPalette.blue,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: SipenaPalette.blue,
          foregroundColor: SipenaPalette.white,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SipenaPalette.navy,
          minimumSize: const Size(44, 46),
          side: const BorderSide(color: SipenaPalette.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: SipenaPalette.white,
        indicatorColor: SipenaPalette.paleTeal,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? SipenaPalette.navy : SipenaPalette.muted,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: SipenaPalette.white,
        selectedColor: SipenaPalette.paleTeal,
        side: const BorderSide(color: SipenaPalette.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: const TextStyle(
          color: SipenaPalette.body,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF8DB5F2),
          brightness: Brightness.dark,
          surface: SipenaPalette.darkSurface,
        ).copyWith(
          primary: const Color(0xFF8DB5F2),
          secondary: const Color(0xFF54C6B7),
          surface: SipenaPalette.darkSurface,
          onSurface: const Color(0xFFEAF1F8),
          error: const Color(0xFFFF8A8A),
        );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SipenaPalette.darkCanvas,
      canvasColor: SipenaPalette.darkCanvas,
      cardColor: SipenaPalette.darkSurface,
      dividerColor: const Color(0xFF384B61),
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      textTheme: _textTheme(const Color(0xFFEAF1F8), const Color(0xFFD5DFEA)),
      appBarTheme: const AppBarTheme(
        backgroundColor: SipenaPalette.darkCanvas,
        foregroundColor: Color(0xFFEAF1F8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: _inputTheme(
        fill: const Color(0xFF1B2838),
        border: const Color(0xFF455970),
        focus: const Color(0xFF8DB5F2),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: SipenaPalette.darkSurface,
        indicatorColor: SipenaPalette.darkSection,
      ),
    );
  }

  static TextTheme _textTheme(Color heading, Color body) => TextTheme(
    headlineLarge: TextStyle(
      color: heading,
      fontSize: 32,
      fontWeight: FontWeight.w800,
      height: 1.12,
    ),
    headlineMedium: TextStyle(
      color: heading,
      fontSize: 27,
      fontWeight: FontWeight.w800,
      height: 1.18,
    ),
    headlineSmall: TextStyle(
      color: heading,
      fontSize: 22,
      fontWeight: FontWeight.w800,
      height: 1.2,
    ),
    titleLarge: TextStyle(
      color: heading,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: heading,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(color: body, fontSize: 15, height: 1.5),
    bodyMedium: TextStyle(color: body, fontSize: 14, height: 1.45),
    bodySmall: TextStyle(color: body, fontSize: 12, height: 1.4),
  );

  static InputDecorationTheme _inputTheme({
    required Color fill,
    required Color border,
    required Color focus,
  }) {
    OutlineInputBorder outline(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: outline(border),
      enabledBorder: outline(border),
      focusedBorder: outline(focus, 1.5),
      errorBorder: outline(SipenaPalette.red),
      focusedErrorBorder: outline(SipenaPalette.red, 1.5),
      hintStyle: const TextStyle(color: SipenaPalette.muted, fontSize: 13),
      labelStyle: const TextStyle(color: SipenaPalette.body, fontSize: 13),
    );
  }
}

enum SipenaStatusTone { waiting, success, revision, rejected }

extension SipenaStatusToneStyle on SipenaStatusTone {
  Color get foreground => switch (this) {
    SipenaStatusTone.waiting => SipenaPalette.gold,
    SipenaStatusTone.success => SipenaPalette.teal,
    SipenaStatusTone.revision => SipenaPalette.blue,
    SipenaStatusTone.rejected => SipenaPalette.red,
  };

  Color get background => switch (this) {
    SipenaStatusTone.waiting => SipenaPalette.paleGold,
    SipenaStatusTone.success => SipenaPalette.paleTeal,
    SipenaStatusTone.revision => SipenaPalette.paleBlue,
    SipenaStatusTone.rejected => SipenaPalette.paleRed,
  };
}

class SipenaSurfaceCard extends StatelessWidget {
  const SipenaSurfaceCard({
    super.key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(20),
    this.radius = SipenaSpacing.radius,
    this.elevated = false,
  });

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: elevated
            ? const [
                BoxShadow(
                  color: Color(0x100D2C52),
                  blurRadius: 18,
                  offset: Offset(0, 7),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

class SipenaIconTile extends StatelessWidget {
  const SipenaIconTile({
    super.key,
    required this.icon,
    required this.color,
    required this.background,
    this.size = 44,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

class SipenaStatusBadge extends StatelessWidget {
  const SipenaStatusBadge({super.key, required this.label, required this.tone});

  final String label;
  final SipenaStatusTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: tone.foreground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class SipenaSectionHeading extends StatelessWidget {
  const SipenaSectionHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: SipenaPalette.muted),
                ),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
