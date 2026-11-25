import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

/// Editorial typography system for BookNest.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayTitle(BuildContext context, {Color? color}) {
    final base = GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.2,
    );
    return base.copyWith(
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle headline(BuildContext context, {Color? color}) {
    final base = GoogleFonts.playfairDisplay(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
      height: 1.25,
    );
    return base.copyWith(
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle sectionTitle(BuildContext context, {Color? color}) {
    final base = GoogleFonts.plusJakartaSans(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.1,
      height: 1.3,
    );
    return base.copyWith(
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bookTitle(BuildContext context, {Color? color, double fontSize = 15}) {
    final base = GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      height: 1.3,
    );
    return base.copyWith(
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle body(BuildContext context, {Color? color, double fontSize = 14}) {
    final base = GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
    return base.copyWith(
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle caption(BuildContext context, {Color? color}) {
    final base = GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
    );
    return base.copyWith(
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  static TextStyle readerBody({
    required double fontSize,
    required Color color,
  }) {
    return GoogleFonts.lora(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      height: 1.75,
      color: color,
    );
  }

  static TextStyle readerHeading({
    required Color color,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      height: 1.3,
      color: color,
    );
  }
}
