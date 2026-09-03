import 'package:flutter/material.dart';
import '../../app/theme/app_borders.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_typography.dart';

/// Neo-Brutalist Filter Pill / Segmented Tab.
/// Used for switching date filters ("Yesterday", "Today", "Tomorrow")
/// or match status ("All", "Live", "Finished").
class NeoTabPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color? activeTextColor;
  final IconData? icon;

  const NeoTabPill({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.activeColor = NeoColors.nsmqRed,
    this.activeTextColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkActive =
        ThemeData.estimateBrightnessForColor(activeColor) == Brightness.dark;
    final Color textColor = isSelected
        ? (activeTextColor ?? (isDarkActive ? NeoColors.textLight : NeoColors.textPrimary))
        : NeoColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : NeoColors.surface,
          borderRadius: NeoBorders.radiusPill,
          border: Border.all(
            color: NeoColors.border,
            width: NeoBorders.strokeDefault,
          ),
          boxShadow: isSelected ? NeoShadows.pill : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: textColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: isSelected
                  ? NeoTypography.headingMedium(color: textColor)
                  : NeoTypography.bodyBold(color: textColor, size: 13),
            ),
          ],
        ),
      ),
    );
  }
}
