import 'package:flutter/material.dart';
import '../../app/theme/app_borders.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_typography.dart';
import 'neo_button.dart';

/// Neo-Brutalist Empty State Widget.
class NeoEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const NeoEmptyState({
    super.key,
    this.icon = Icons.sports_score_outlined,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: NeoColors.surface,
            borderRadius: NeoBorders.radiusLg,
            border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
            boxShadow: NeoShadows.card,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: NeoColors.surfaceBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                  boxShadow: NeoShadows.pill,
                ),
                child: Icon(icon, size: 36, color: NeoColors.nsmqBlue),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: NeoTypography.headingMedium(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: NeoTypography.bodyRegular(color: NeoColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: 20),
                NeoButton(
                  text: actionText!,
                  onPressed: onAction,
                  backgroundColor: NeoColors.nsmqRed,
                  textColor: NeoColors.textLight,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
