import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';

class NeoBottomNavItem {
  final IconData icon;
  final String label;

  const NeoBottomNavItem({
    required this.icon,
    required this.label,
  });
}

class NeoBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NeoBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<NeoBottomNavItem> items = [
    NeoBottomNavItem(icon: Icons.flash_on, label: 'CONTESTS'),
    NeoBottomNavItem(icon: Icons.emoji_events, label: 'BRACKET'),
    NeoBottomNavItem(icon: Icons.school, label: 'SCHOOLS'),
    NeoBottomNavItem(icon: Icons.newspaper, label: 'FEED'),
    NeoBottomNavItem(icon: Icons.star, label: 'FAVORITES'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NeoColors.surface,
        border: Border(
          top: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      color: isSelected ? NeoColors.nsmqRed : Colors.transparent,
                      borderRadius: NeoBorders.radiusSm,
                      border: isSelected
                          ? Border.all(color: NeoColors.border, width: NeoBorders.strokeThin)
                          : null,
                      boxShadow: isSelected ? NeoShadows.pill : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: isSelected ? NeoColors.textLight : NeoColors.textSecondary,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: NeoTypography.badge(
                            color: isSelected ? NeoColors.textLight : NeoColors.textSecondary,
                          ).copyWith(fontSize: 9),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
