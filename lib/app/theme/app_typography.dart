import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Neo-Brutalist Typography System.
/// - Big texts, Headings, Scores & Badges: Archivo Black
/// - Body, Commentary, Details & Metadata: IBM Plex Sans
class NeoTypography {
  NeoTypography._();

  // ---------------------------------------------------------------------------
  // Archivo Black: High-impact display, scores, headers, and school names
  // ---------------------------------------------------------------------------

  /// Massive score counters & hero banners (e.g. 58 - 42)
  static TextStyle displayLarge({Color color = NeoColors.textPrimary}) =>
      GoogleFonts.archivoBlack(
        fontSize: 32,
        height: 1.1,
        color: color,
        letterSpacing: -0.5,
      );

  /// Screen main headers & hero titles
  static TextStyle displayMedium({Color color = NeoColors.textPrimary}) =>
      GoogleFonts.archivoBlack(
        fontSize: 24,
        height: 1.15,
        color: color,
      );

  /// Contest card school names & stage titles (e.g. "PRESEC LEGON")
  static TextStyle headingLarge({Color color = NeoColors.textPrimary}) =>
      GoogleFonts.archivoBlack(
        fontSize: 18,
        height: 1.2,
        color: color,
      );

  /// Subsections, folder tabs, button labels
  static TextStyle headingMedium({Color color = NeoColors.textPrimary}) =>
      GoogleFonts.archivoBlack(
        fontSize: 15,
        height: 1.2,
        color: color,
      );

  /// Scoreboard matrix digits & score pills
  static TextStyle scoreText({Color color = NeoColors.textPrimary, double size = 16}) =>
      GoogleFonts.archivoBlack(
        fontSize: size,
        height: 1.0,
        color: color,
      );

  /// Tiny badge labels (e.g. "LIVE", "FT", "R3")
  static TextStyle badge({Color color = NeoColors.textPrimary}) =>
      GoogleFonts.archivoBlack(
        fontSize: 11,
        height: 1.0,
        color: color,
        letterSpacing: 0.5,
      );

  // ---------------------------------------------------------------------------
  // IBM Plex Sans: Clean, industrial, high-legibility body & technical copy
  // ---------------------------------------------------------------------------

  /// Emphasized body text, contestant full names
  static TextStyle bodyBold({Color color = NeoColors.textPrimary, double size = 14}) =>
      GoogleFonts.ibmPlexSans(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
      );

  /// Standard body text, play-by-play commentary descriptions
  static TextStyle bodyMedium({Color color = NeoColors.textPrimary, double size = 13}) =>
      GoogleFonts.ibmPlexSans(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      );

  /// Supporting descriptions, rules, timestamps
  static TextStyle bodyRegular({Color color = NeoColors.textSecondary, double size = 12}) =>
      GoogleFonts.ibmPlexSans(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );

  /// Small metadata, round subtitles, location
  static TextStyle caption({Color color = NeoColors.textSecondary}) =>
      GoogleFonts.ibmPlexSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color,
      );
}
