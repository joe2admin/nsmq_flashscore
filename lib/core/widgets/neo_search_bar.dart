import 'package:flutter/material.dart';
import '../../app/theme/app_borders.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_typography.dart';

/// Neo-Brutalist Search Bar for searching matches, schools, and tournament stages.
class NeoSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final EdgeInsetsGeometry margin;

  const NeoSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.hintText = 'Search schools, stages, or contests...',
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: NeoTypography.bodyBold(),
        cursorColor: NeoColors.nsmqRed,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: NeoTypography.bodyRegular(color: NeoColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: NeoColors.textPrimary, size: 20),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: NeoColors.textPrimary, size: 18),
                  onPressed: () {
                    controller?.clear();
                    onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        ),
      ),
    );
  }
}
