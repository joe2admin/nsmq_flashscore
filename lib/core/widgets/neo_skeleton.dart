import 'package:flutter/material.dart';
import '../../app/theme/app_borders.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';

/// Sweeping gradient transform for NeoSkeletonShimmer.
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * (2.0 * slidePercent - 1.0),
      0.0,
      0.0,
    );
  }
}

/// A high-performance, zero-dependency shimmer effect that sweeps
/// across its child widgets. Coordinates skeleton bones into a smooth animation.
class NeoSkeletonShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const NeoSkeletonShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE2E2E8),
    this.highlightColor = const Color(0xFFF8F8FA),
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<NeoSkeletonShimmer> createState() => _NeoSkeletonShimmerState();
}

class _NeoSkeletonShimmerState extends State<NeoSkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: const Alignment(-1.0, -0.2),
              end: const Alignment(1.0, 0.2),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Primitive skeleton bone shape for building placeholder layouts.
class NeoSkeletonBone extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? color;
  final BoxShape shape;
  final BoxBorder? border;

  const NeoSkeletonBone({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
    this.shape = BoxShape.rectangle,
    this.border,
  });

  const NeoSkeletonBone.circle({
    super.key,
    required double size,
    this.color,
    this.border,
  })  : width = size,
        height = size,
        borderRadius = null,
        shape = BoxShape.circle;

  const NeoSkeletonBone.line({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius,
    this.color,
    this.border,
  }) : shape = BoxShape.rectangle;

  const NeoSkeletonBone.badge({
    super.key,
    this.width = 64,
    this.height = 20,
    this.borderRadius,
    this.color,
    this.border,
  }) : shape = BoxShape.rectangle;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? const Color(0xFFE2E2E8);
    final effectiveRadius = shape == BoxShape.circle
        ? null
        : (borderRadius ?? NeoBorders.radiusSm);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: effectiveColor,
        shape: shape,
        borderRadius: effectiveRadius,
        border: border,
      ),
    );
  }
}

/// Neo-Brutalist card shell for holding skeleton bones.
/// Retains crisp 2.5px solid black border and hard offset drop shadow.
class NeoSkeletonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double borderWidth;
  final Color backgroundColor;

  const NeoSkeletonCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderRadius,
    this.borderWidth = NeoBorders.strokeDefault,
    this.backgroundColor = NeoColors.surface,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? NeoBorders.radiusMd;

    Widget cardBody = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(color: NeoColors.border, width: borderWidth),
        boxShadow: NeoShadows.card,
      ),
      child: child,
    );

    if (margin != null) {
      cardBody = Padding(padding: margin!, child: cardBody);
    }

    return cardBody;
  }
}

/// Neo-Brutalist Folder Card skeleton shell mimicking NeoFolderCard.
class NeoSkeletonFolderCard extends StatelessWidget {
  final Widget child;
  final double tabWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const NeoSkeletonFolderCard({
    super.key,
    required this.child,
    this.tabWidth = 140,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
    this.margin = const EdgeInsets.only(bottom: 20),
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Folder Tab Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Tab ear
            Container(
              width: tabWidth,
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                border: Border(
                  top: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
                  left: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
                  right: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
                ),
              ),
              child: const NeoSkeletonBone.line(height: 12),
            ),

            // Trailing badge placeholder
            const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: NeoSkeletonBone.badge(width: 72, height: 22),
            ),
          ],
        ),

        // Main Folder Body
        Container(
          width: double.infinity,
          padding: padding,
          decoration: const BoxDecoration(
            color: NeoColors.surface,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            border: Border.fromBorderSide(
              BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
            ),
            boxShadow: NeoShadows.card,
          ),
          child: child,
        ),
      ],
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
