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
  static const darkBorder = Color(0xFF384B61);
  static const darkMuted = Color(0xFFA6B5C7);
  static const darkBlue = Color(0xFF8DB5F2);
  static const darkTeal = Color(0xFF54C6B7);
  static const darkGold = Color(0xFFFFD166);
  static const darkRed = Color(0xFFFF8A8A);
}

extension SipenaThemeColors on BuildContext {
  bool get isSipenaDark => Theme.of(this).brightness == Brightness.dark;

  Color get sipenaCardColor =>
      isSipenaDark ? SipenaPalette.darkSurface : SipenaPalette.white;

  Color get sipenaInsetColor =>
      isSipenaDark ? const Color(0xFF253447) : const Color(0xFFF7F9FC);

  Color get sipenaBorderColor =>
      isSipenaDark ? SipenaPalette.darkBorder : SipenaPalette.line;

  Color get sipenaInputBorderColor =>
      isSipenaDark ? const Color(0xFF52677F) : const Color(0xFFE1E7EF);

  Color get sipenaHeadingColor =>
      isSipenaDark ? const Color(0xFFEAF1F8) : SipenaPalette.ink;

  Color get sipenaTextColor =>
      isSipenaDark ? const Color(0xFFD5DFEA) : SipenaPalette.body;

  Color get sipenaMutedTextColor =>
      isSipenaDark ? SipenaPalette.darkMuted : SipenaPalette.muted;

  Color get sipenaSubtleTextColor =>
      isSipenaDark ? const Color(0xFF91A2B7) : const Color(0xFF8290A1);

  Color get sipenaAccentColor =>
      isSipenaDark ? SipenaPalette.darkBlue : SipenaPalette.blue;

  Color get sipenaAccentSurfaceColor =>
      isSipenaDark ? SipenaPalette.darkSection : SipenaPalette.paleBlue;

  Color get sipenaSectionColor =>
      isSipenaDark ? SipenaPalette.darkSection : SipenaPalette.section;

  Color get sipenaDangerColor =>
      isSipenaDark ? SipenaPalette.darkRed : SipenaPalette.red;

  Color get sipenaActivityResearchColor =>
      isSipenaDark ? SipenaPalette.darkBlue : SipenaPalette.blue;

  Color get sipenaActivityResearchTint =>
      isSipenaDark ? const Color(0xFF263C58) : SipenaPalette.paleBlue;

  Color get sipenaActivityCommunityColor =>
      isSipenaDark ? SipenaPalette.darkTeal : SipenaPalette.teal;

  Color get sipenaActivityCommunityTint =>
      isSipenaDark ? const Color(0xFF1E403F) : SipenaPalette.paleTeal;

  Color get sipenaStatusWaitingColor =>
      isSipenaDark ? SipenaPalette.darkGold : SipenaPalette.gold;

  Color get sipenaStatusWaitingTint =>
      isSipenaDark ? const Color(0xFF493C25) : SipenaPalette.paleGold;

  Color get sipenaStatusSuccessColor =>
      isSipenaDark ? SipenaPalette.darkTeal : SipenaPalette.teal;

  Color get sipenaStatusSuccessTint =>
      isSipenaDark ? const Color(0xFF1E403F) : SipenaPalette.paleTeal;

  Color get sipenaStatusRevisionColor =>
      isSipenaDark ? SipenaPalette.darkBlue : SipenaPalette.blue;

  Color get sipenaStatusRevisionTint =>
      isSipenaDark ? const Color(0xFF263C58) : SipenaPalette.paleBlue;

  Color get sipenaStatusRejectedColor =>
      isSipenaDark ? SipenaPalette.darkRed : SipenaPalette.red;

  Color get sipenaStatusRejectedTint =>
      isSipenaDark ? const Color(0xFF4A2C35) : SipenaPalette.paleRed;
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
      fontFamily: 'Quicksand',
      textTheme: _textTheme(SipenaPalette.ink, SipenaPalette.body),
      appBarTheme: const AppBarTheme(
        backgroundColor: SipenaPalette.canvas,
        foregroundColor: SipenaPalette.navy,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Quicksand',
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
      dialogTheme: const DialogThemeData(
        backgroundColor: SipenaPalette.white,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: SipenaPalette.ink,
        contentTextStyle: TextStyle(color: SipenaPalette.white),
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
          onPrimary: SipenaPalette.darkCanvas,
          primaryContainer: const Color(0xFF29466B),
          onPrimaryContainer: const Color(0xFFEAF1F8),
          secondary: const Color(0xFF54C6B7),
          onSecondary: SipenaPalette.darkCanvas,
          secondaryContainer: const Color(0xFF1E403F),
          onSecondaryContainer: const Color(0xFFD7F5EF),
          tertiary: SipenaPalette.darkGold,
          onTertiary: SipenaPalette.darkCanvas,
          surface: SipenaPalette.darkSurface,
          onSurface: const Color(0xFFEAF1F8),
          surfaceContainerHighest: const Color(0xFF253447),
          onSurfaceVariant: const Color(0xFFCAD5E2),
          error: const Color(0xFFFF8A8A),
          onError: const Color(0xFF321317),
          errorContainer: const Color(0xFF4A2C35),
          onErrorContainer: const Color(0xFFFFDADD),
        );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SipenaPalette.darkCanvas,
      canvasColor: SipenaPalette.darkCanvas,
      cardColor: SipenaPalette.darkSurface,
      dividerColor: SipenaPalette.darkBorder,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      fontFamily: 'Quicksand',
      textTheme: _textTheme(const Color(0xFFEAF1F8), const Color(0xFFD5DFEA))
          .apply(
            bodyColor: const Color(0xFFD5DFEA),
            displayColor: const Color(0xFFEAF1F8),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: SipenaPalette.darkCanvas,
        foregroundColor: Color(0xFFEAF1F8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: _inputTheme(
        fill: const Color(0xFF1B2838),
        border: const Color(0xFF52677F),
        focus: SipenaPalette.darkBlue,
        hint: const Color(0xFFA6B5C7),
        label: const Color(0xFFCAD5E2),
        error: SipenaPalette.darkRed,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: SipenaPalette.darkBlue,
          foregroundColor: SipenaPalette.darkCanvas,
          disabledBackgroundColor: const Color(0xFF394A60),
          disabledForegroundColor: const Color(0xFFAFBBC9),
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SipenaPalette.darkBlue,
          side: const BorderSide(color: Color(0xFF52677F)),
          minimumSize: const Size(44, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: SipenaPalette.darkBlue),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: const Color(0xFFCAD5E2)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: SipenaPalette.darkSurface,
        selectedColor: SipenaPalette.darkSection,
        disabledColor: const Color(0xFF253447),
        side: const BorderSide(color: SipenaPalette.darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: const TextStyle(
          color: Color(0xFFD5DFEA),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: const TextStyle(color: Color(0xFFEAF1F8)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: SipenaPalette.darkSurface,
        indicatorColor: SipenaPalette.darkSection,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? const Color(0xFFEAF1F8) : const Color(0xFFA6B5C7),
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SipenaPalette.darkCanvas;
          }
          return const Color(0xFFCAD5E2);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SipenaPalette.darkTeal;
          }
          return const Color(0xFF455970);
        }),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: SipenaPalette.darkSurface,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: SipenaPalette.darkSection,
        contentTextStyle: TextStyle(color: Color(0xFFEAF1F8)),
      ),
    );
  }

  static TextTheme _textTheme(Color heading, Color body) => TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Quicksand',
      color: heading,
      fontSize: 32,
      fontWeight: FontWeight.w800,
      height: 1.12,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Quicksand',
      color: heading,
      fontSize: 27,
      fontWeight: FontWeight.w800,
      height: 1.18,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Quicksand',
      color: heading,
      fontSize: 22,
      fontWeight: FontWeight.w800,
      height: 1.2,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Quicksand',
      color: heading,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Quicksand',
      color: heading,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Quicksand',
      color: body,
      fontSize: 15,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Quicksand',
      color: body,
      fontSize: 14,
      height: 1.45,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Quicksand',
      color: body,
      fontSize: 12,
      height: 1.4,
    ),
  );

  static InputDecorationTheme _inputTheme({
    required Color fill,
    required Color border,
    required Color focus,
    Color hint = SipenaPalette.muted,
    Color label = SipenaPalette.body,
    Color error = SipenaPalette.red,
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
      errorBorder: outline(error),
      focusedErrorBorder: outline(error, 1.5),
      hintStyle: TextStyle(color: hint, fontSize: 13),
      labelStyle: TextStyle(color: label, fontSize: 13),
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
        color: switch (tone) {
          SipenaStatusTone.waiting => context.sipenaStatusWaitingTint,
          SipenaStatusTone.success => context.sipenaStatusSuccessTint,
          SipenaStatusTone.revision => context.sipenaStatusRevisionTint,
          SipenaStatusTone.rejected => context.sipenaStatusRejectedTint,
        },
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: switch (tone) {
            SipenaStatusTone.waiting => context.sipenaStatusWaitingColor,
            SipenaStatusTone.success => context.sipenaStatusSuccessColor,
            SipenaStatusTone.revision => context.sipenaStatusRevisionColor,
            SipenaStatusTone.rejected => context.sipenaStatusRejectedColor,
          },
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
                      ?.copyWith(color: context.sipenaMutedTextColor),
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
