import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/tournament_stage.dart';
import 'stage_bracket_card.dart';

/// Renders the 3-into-1 bracket branch lines linking feeder matches to subsequent rounds.
class BracketForkPainter extends CustomPainter {
  /// Y-center positions (as proportions 0.0 to 1.0) of the feeder cards.
  final List<double> cardCenterYFractions;
  final Color lineColor;
  final double strokeWidth;

  BracketForkPainter({
    required this.cardCenterYFractions,
    this.lineColor = NeoColors.border,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (cardCenterYFractions.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final spineX = size.width * 0.55;
    final endX = size.width;

    if (cardCenterYFractions.length == 1) {
      final y = cardCenterYFractions[0] * size.height;
      canvas.drawLine(Offset(0, y), Offset(endX, y), paint);
      return;
    }

    final minY = cardCenterYFractions.first * size.height;
    final maxY = cardCenterYFractions.last * size.height;
    final midIndex = cardCenterYFractions.length ~/ 2;
    final midY = cardCenterYFractions[midIndex] * size.height;

    // Draw horizontal feeder branches from cards to the spine
    for (final frac in cardCenterYFractions) {
      final y = frac * size.height;
      canvas.drawLine(Offset(0, y), Offset(spineX, y), paint);
    }

    // Draw vertical spine connecting top-most to bottom-most branch
    canvas.drawLine(Offset(spineX, minY), Offset(spineX, maxY), paint);

    // Draw advancing branch extending to the right edge
    canvas.drawLine(Offset(spineX, midY), Offset(endX, midY), paint);
  }

  @override
  bool shouldRepaint(covariant BracketForkPainter oldDelegate) {
    return oldDelegate.cardCenterYFractions != cardCenterYFractions ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Incoming connector stub entering from the left edge of a stage into a contest card.
class BracketIncomingStub extends StatelessWidget {
  final double width;
  final Color color;
  final double strokeWidth;

  const BracketIncomingStub({
    super.key,
    this.width = 12.0,
    this.color = NeoColors.border,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: strokeWidth,
      color: color,
    );
  }
}

/// Groups up to 3 contest cards and renders visual bracket connector lines (incoming / outgoing)
class BracketStageGroup extends StatelessWidget {
  final List<StageContestPreview> contests;
  final bool isPreliminary;
  final bool isGrandFinale;
  final bool showOutgoingConnectors;
  final bool showIncomingConnectors;
  final void Function(StageContestPreview)? onContestTap;

  const BracketStageGroup({
    super.key,
    required this.contests,
    this.isPreliminary = false,
    this.isGrandFinale = false,
    this.showOutgoingConnectors = false,
    this.showIncomingConnectors = false,
    this.onContestTap,
  });

  @override
  Widget build(BuildContext context) {
    if (contests.isEmpty) return const SizedBox.shrink();

    // Compute fractions for the centers of the cards:
    // With N cards, each card occupies 1/N of the vertical height.
    final count = contests.length;
    final fractions = List.generate(count, (i) => (i + 0.5) / count);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left incoming connector (e.g. For Semis and Grand Finale)
          if (showIncomingConnectors) ...[
            Center(
              child: Container(
                width: 12,
                height: 2,
                color: NeoColors.border,
              ),
            ),
            const SizedBox(width: 4),
          ],

          // Cards column
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: contests.map((contest) {
                return StageBracketCard(
                  contest: contest,
                  isPreliminary: isPreliminary,
                  isGrandFinale: isGrandFinale,
                  onTap: () => onContestTap?.call(contest),
                );
              }).toList(),
            ),
          ),

          // Right outgoing bracket fork (e.g. for Quarter-Finals and Semi-Finals)
          if (showOutgoingConnectors) ...[
            const SizedBox(width: 4),
            SizedBox(
              width: 24,
              child: CustomPaint(
                painter: BracketForkPainter(
                  cardCenterYFractions: fractions,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
