import 'package:flutter/material.dart';
import '../../app/theme/app_borders.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_typography.dart';

/// Neo-Brutalist Folder Tab Card.
/// Features a file-folder shape with a raised index tab on top.
class NeoFolderCard extends StatelessWidget {
  final String tabText;
  final IconData? tabIcon;
  final Color tabColor;
  final Color? tabTextColor;
  final Color cardColor;
  final Widget child;
  final Widget? trailingBadge;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const NeoFolderCard({
    super.key,
    required this.tabText,
    this.tabIcon,
    this.tabColor = NeoColors.nsmqBlue,
    this.tabTextColor,
    this.cardColor = NeoColors.surface,
    required this.child,
    this.trailingBadge,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkTab =
        ThemeData.estimateBrightnessForColor(tabColor) == Brightness.dark;
    final Color effectiveTabTextColor =
        tabTextColor ?? (isDarkTab ? NeoColors.textLight : NeoColors.textPrimary);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // The Raised Folder Tab Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Top Tab (Flexible to avoid overflowing against trailingBadge)
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  border: const Border(
                    top: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
                    left: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
                    right: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
                    bottom: BorderSide.none,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tabIcon != null) ...[
                      Icon(tabIcon, size: 14, color: effectiveTabTextColor),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        tabText.toUpperCase(),
                        style: NeoTypography.badge(color: effectiveTabTextColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (trailingBadge != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: trailingBadge!,
              ),
          ],
        ),

        // The Main Card Body with Hard Drop Shadow
        Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(14),
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
            border: Border.all(
              color: NeoColors.border,
              width: NeoBorders.strokeDefault,
            ),
            boxShadow: NeoShadows.card,
          ),
          child: child,
        ),
      ],
    );

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
