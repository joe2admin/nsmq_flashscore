import 'package:flutter/material.dart';
import '../../app/theme/app_borders.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_typography.dart';

/// Tactile Neo-Brutalist Button.
/// Provides a physical arcade-style press effect:
/// Translates down-right and collapses shadow on press.
class NeoButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isDense;

  const NeoButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.backgroundColor = NeoColors.yellow,
    this.textColor = NeoColors.textPrimary,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.width,
    this.height,
    this.borderRadius,
    this.isDense = false,
  }) : assert(text != null || child != null);

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? NeoBorders.radiusMd;
    final isEnabled = widget.onPressed != null;

    final effectiveColor = isEnabled ? widget.backgroundColor : NeoColors.neutral;
    final effectiveShadow = _isPressed || !isEnabled ? NeoShadows.pressed : NeoShadows.card;
    final translateOffset = _isPressed ? const Offset(2.0, 2.0) : Offset.zero;

    Widget content = widget.child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: widget.isDense ? 16 : 18, color: widget.textColor),
              const SizedBox(width: 8),
            ],
            Text(
              widget.text!,
              style: widget.isDense
                  ? NeoTypography.badge(color: widget.textColor)
                  : NeoTypography.headingMedium(color: widget.textColor),
            ),
          ],
        );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        transform: Matrix4.translationValues(translateOffset.dx, translateOffset.dy, 0),
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: radius,
          border: Border.all(
            color: NeoColors.border,
            width: NeoBorders.strokeDefault,
          ),
          boxShadow: effectiveShadow,
        ),
        child: content,
      ),
    );
  }
}
