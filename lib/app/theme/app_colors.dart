import 'package:flutter/material.dart';

/// Neo-Brutalist Color Palette for NSMQ Flashscore.
/// Rooted in Ghana's National Science & Maths Quiz (NSMQ) official brand identity:
/// Primary Crimson Red (#D00606), Electric Red (#FF0000 -> #FF1E27),
/// Deep Royal Blue (#1A11E9 -> #1611D4), and Electric Indigo (#4400FF).
/// Carefully tuned with neo-brutalism best practices for high commercial legibility.
class NeoColors {
  NeoColors._();

  // ---------------------------------------------------------------------------
  // 1. NSMQ Core Brand Identity (Reference Image)
  // ---------------------------------------------------------------------------

  /// Official NSMQ Crimson (#D00606) - Primary brand anchor, dominant banners
  static const Color nsmqRed = Color(0xFFD00606);

  /// NSMQ Electric Red (#FF0000 adjusted to #FF1E27 for optimal screen contrast)
  /// Used for LIVE indicators, high-stakes buzzer tension, penalties (-1)
  static const Color nsmqBrightRed = Color(0xFFFF1E27);

  /// Official NSMQ Deep Royal Blue (#1A11E9 adjusted to #1611D4)
  /// Used for stage headers, tournament branding, Science rounds
  static const Color nsmqBlue = Color(0xFF1611D4);

  /// Official NSMQ Electric Indigo / Violet-Blue (#4400FF)
  /// High-energy accent, Problem of the Day, riddle bonanza
  static const Color nsmqElectricBlue = Color(0xFF4400FF);

  // ---------------------------------------------------------------------------
  // 2. High-Contrast Neo-Brutalist Canvas & Outlines
  // ---------------------------------------------------------------------------

  /// Pure Pitch Black (#000000) - For crisp 2.5px solid borders, 0-blur shadows & primary headers
  static const Color border = Color(0xFF000000);
  static const Color shadow = Color(0xFF000000);
  static const Color textPrimary = Color(0xFF000000);
  static const Color darkCanvas = Color(0xFF121217);

  /// Pure Crisp White (#FFFFFF) - Card faces, button text on dark fills
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textLight = Color(0xFFFFFFFF);

  /// Warm Ivory / Editorial Paper Canvas (#FAF8F5)
  /// Softens screen glare while letting solid black outlines and vivid cards punch through
  static const Color background = Color(0xFFFAF8F5);

  /// Subtle gray for dividers, disabled controls, unselected pills
  static const Color neutralMuted = Color(0xFFEEEEF2);
  static const Color textSecondary = Color(0xFF4C4D58);

  // ---------------------------------------------------------------------------
  // 3. Commercial Neo-Brutalist Soft Tints (Card & Pill Backgrounds)
  // ---------------------------------------------------------------------------

  /// Soft Red Surface Tint - for penalty warnings & alert containers
  static const Color surfaceRed = Color(0xFFFFEBEB);

  /// Soft Blue Surface Tint - for science question cards & round containers
  static const Color surfaceBlue = Color(0xFFECEBFF);

  /// Soft Yellow Surface Tint - for leader highlights
  static const Color surfaceYellow = Color(0xFFFFFBE6);

  // ---------------------------------------------------------------------------
  // 4. Functional Flashscore Tournament Accents
  // ---------------------------------------------------------------------------

  /// NSMQ Trophy Gold (#FFC700) - Winner badges, championship leader highlight
  static const Color gold = Color(0xFFFFC700);

  /// Vibrant Mint Green (#10B981) - Correct answers, bonus points (+1, +3)
  static const Color green = Color(0xFF10B981);

  // Backward compatibility convenience aliases
  static const Color yellow = gold;
  static const Color coral = nsmqBrightRed;
  static const Color blue = nsmqBlue;
  static const Color purple = nsmqElectricBlue;
  static const Color peach = Color(0xFFFF8B53);
  static const Color neutral = neutralMuted;
  static const Color surfaceMuted = Color(0xFFF3F3F7);
}
