import 'package:flutter/material.dart';
import '../../app/theme/app_borders.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';

/// Standard Neo-Brutalist Card Container.
/// Features a solid black border and hard offset drop shadow.
class NeoCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double borderWidth;
  final List<BoxShadow>? shadow;
  final VoidCallback? onTap;

  const NeoCard({
    super.key,
    required this.child,
    this.backgroundColor = NeoColors.surface,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderRadius,
    this.borderWidth = NeoBorders.strokeDefault,
    this.shadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? NeoBorders.radiusMd;
    final effectiveShadow = shadow ?? NeoShadows.card;

    Widget cardBody = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(color: NeoColors.border, width: borderWidth),
        boxShadow: effectiveShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      cardBody = GestureDetector(
        onTap: onTap,
        child: cardBody,
      );
    }

    if (margin != null) {
      cardBody = Padding(padding: margin!, child: cardBody);
    }

    return cardBody;
  }
}
