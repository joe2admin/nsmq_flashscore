import 'package:flutter/material.dart';
import '../../app/theme/app_borders.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_typography.dart';

/// High-contrast Neo-Brutalist Badge / Chip aligned with NSMQ theme colors.
class NeoBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final bool hasShadow;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const NeoBadge({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor = NeoColors.nsmqBlue,
    this.textColor = NeoColors.textLight,
    this.borderColor = NeoColors.border,
    this.hasShadow = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.fontSize = 11,
  });

  /// Factory for the high-visibility LIVE badge in NSMQ Electric Red
  factory NeoBadge.live({String text = 'LIVE'}) => NeoBadge(
        text: text,
        backgroundColor: NeoColors.nsmqBrightRed,
        textColor: NeoColors.textLight,
        icon: Icons.fiber_manual_record,
      );

  /// Factory for Finished / FT badge in neutral gray
  factory NeoBadge.finished({String text = 'FT'}) => NeoBadge(
        text: text,
        backgroundColor: NeoColors.neutralMuted,
        textColor: NeoColors.textPrimary,
      );

  /// Factory for penalty point deduction in NSMQ Red
  factory NeoBadge.penalty({String text = '-1 PENALTY'}) => NeoBadge(
        text: text,
        backgroundColor: NeoColors.nsmqRed,
        textColor: NeoColors.textLight,
        icon: Icons.warning_amber_rounded,
      );

  /// Factory for bonus points (+1) in vibrant Green
  factory NeoBadge.bonus({String text = '+1 BONUS'}) => NeoBadge(
        text: text,
        backgroundColor: NeoColors.green,
        textColor: NeoColors.textLight,
      );

  /// Factory for NSMQ Stages (1/8th Stage, Quarter-Finals, Finale)
  factory NeoBadge.stage(String stageText) => NeoBadge(
        text: stageText,
        backgroundColor: NeoColors.nsmqBlue,
        textColor: NeoColors.textLight,
        icon: Icons.emoji_events_outlined,
      );

  /// Factory for Round Pills (R1, R2, R3, R4, R5)
  factory NeoBadge.round(String roundText, {bool isActive = false}) => NeoBadge(
        text: roundText,
        backgroundColor: isActive ? NeoColors.nsmqElectricBlue : NeoColors.surface,
        textColor: isActive ? NeoColors.textLight : NeoColors.textPrimary,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: NeoBorders.radiusPill,
        border: Border.all(color: borderColor, width: NeoBorders.strokeThin),
        boxShadow: hasShadow ? NeoShadows.pill : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text.toUpperCase(),
            style: NeoTypography.badge(color: textColor).copyWith(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
