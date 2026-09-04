import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/school_badge_avatar.dart';

import '../../../../core/constants/school_assets.dart';

/// A custom-rendered Trophy illustration and NSMQ Champion card
/// matching the Grand Finale wireframe design.
class TrophyChampionWidget extends StatelessWidget {
  final String? championSchool;
  final String? titles;
  final VoidCallback? onTap;

  const TrophyChampionWidget({
    super.key,
    this.championSchool,
    this.titles,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasChampion = championSchool != null && championSchool!.trim().isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),

        // Exact NSMQ Championship Cup / Trophy
        Image.asset(
          SchoolAssets.nsmqTrophy,
          height: 220,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return SizedBox(
              width: 180,
              height: 150,
              child: CustomPaint(
                painter: _TrophyPainter(),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // NSMQ Champion Card or Awaiting Champion Card
        GestureDetector(
          onTap: hasChampion ? onTap : null,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: NeoBorders.radiusMd,
              border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
              boxShadow: NeoShadows.card,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hasChampion ? 'NSMQ CHAMPION' : 'CHAMPIONSHIP TROPHY',
                  style: NeoTypography.headingLarge(
                    color: hasChampion ? NeoColors.nsmqRed : NeoColors.nsmqBlue,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                if (hasChampion)
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      SchoolBadgeAvatar(schoolName: championSchool!, size: 20),
                      Text(
                        championSchool!,
                        style: NeoTypography.headingMedium(),
                      ),
                      if (titles != null && titles!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: NeoColors.surfaceYellow,
                            borderRadius: NeoBorders.radiusSm,
                            border: Border.all(color: NeoColors.border, width: 1),
                          ),
                          child: Text(
                            titles!,
                            style: NeoTypography.badge(color: NeoColors.nsmqBlue),
                          ),
                        ),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: NeoColors.surfaceYellow,
                      borderRadius: NeoBorders.radiusSm,
                      border: Border.all(color: NeoColors.border, width: 1),
                    ),
                    child: Text(
                      'AWAITING 2026 CHAMPION',
                      style: NeoTypography.badge(color: NeoColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

class _TrophyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = NeoColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final goldFill = Paint()
      ..color = NeoColors.gold
      ..style = PaintingStyle.fill;

    final darkGoldFill = Paint()
      ..color = const Color(0xFFE5A800)
      ..style = PaintingStyle.fill;

    final whiteFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final topY = size.height * 0.12;

    // Sparkles around trophy
    _drawSparkle(canvas, centerX - 62, topY + 12, 7);
    _drawSparkle(canvas, centerX + 62, topY + 8, 8);
    _drawSparkle(canvas, centerX - 55, topY + 68, 5);
    _drawSparkle(canvas, centerX + 56, topY + 62, 6);

    // Handles on Left and Right
    final leftHandle = Path()
      ..moveTo(centerX - 36, topY + 14)
      ..cubicTo(centerX - 68, topY + 14, centerX - 68, topY + 54, centerX - 28, topY + 54);
    canvas.drawPath(leftHandle, strokePaint);

    final rightHandle = Path()
      ..moveTo(centerX + 36, topY + 14)
      ..cubicTo(centerX + 68, topY + 14, centerX + 68, topY + 54, centerX + 28, topY + 54);
    canvas.drawPath(rightHandle, strokePaint);

    // Cup Body
    final cupPath = Path()
      ..moveTo(centerX - 38, topY)
      ..lineTo(centerX + 38, topY)
      ..cubicTo(centerX + 36, topY + 48, centerX + 22, topY + 64, centerX + 10, topY + 68)
      ..lineTo(centerX - 10, topY + 68)
      ..cubicTo(centerX - 22, topY + 64, centerX - 36, topY + 48, centerX - 38, topY)
      ..close();

    canvas.drawPath(cupPath, goldFill);
    canvas.drawPath(cupPath, strokePaint);

    // Cup Rim
    final rimRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(centerX, topY), width: 80, height: 10),
      const Radius.circular(5),
    );
    canvas.drawRRect(rimRect, darkGoldFill);
    canvas.drawRRect(rimRect, strokePaint);

    // Star in the center of the cup
    _drawStar(canvas, Offset(centerX, topY + 34), 11, 5, whiteFill, strokePaint);

    // Stem / Neck
    final stemRect = Rect.fromCenter(center: Offset(centerX, topY + 76), width: 14, height: 16);
    canvas.drawRect(stemRect, darkGoldFill);
    canvas.drawRect(stemRect, strokePaint);

    // Base Tier 1
    final base1 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(centerX, topY + 88), width: 44, height: 10),
      const Radius.circular(3),
    );
    canvas.drawRRect(base1, goldFill);
    canvas.drawRRect(base1, strokePaint);

    // Base Tier 2 (Pedestal block)
    final pedestal = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(centerX, topY + 104), width: 62, height: 22),
      const Radius.circular(4),
    );
    canvas.drawRRect(pedestal, whiteFill);
    canvas.drawRRect(pedestal, strokePaint);

    // Small plaque on pedestal
    final plaque = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(centerX, topY + 104), width: 44, height: 12),
      const Radius.circular(2),
    );
    canvas.drawRRect(plaque, goldFill);
    canvas.drawRRect(plaque, strokePaint);
  }

  void _drawSparkle(Canvas canvas, double x, double y, double radius) {
    final path = Path()
      ..moveTo(x, y - radius)
      ..quadraticBezierTo(x, y, x + radius, y)
      ..quadraticBezierTo(x, y, x, y + radius)
      ..quadraticBezierTo(x, y, x - radius, y)
      ..quadraticBezierTo(x, y, x, y - radius)
      ..close();

    final fill = Paint()..color = NeoColors.gold;
    final stroke = Paint()
      ..color = NeoColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  void _drawStar(Canvas canvas, Offset center, double outerRadius, double innerRadius, Paint fill, Paint stroke) {
    final path = Path();
    const points = 5;
    final double step = math.pi / points;
    double angle = -math.pi / 2;

    for (int i = 0; i < points * 2; i++) {
      final double r = i.isEven ? outerRadius : innerRadius;
      final double x = center.dx + r * math.cos(angle);
      final double y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += step;
    }
    path.close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
