import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/nsmq_constants.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';

class RoundBreakdownTable extends StatelessWidget {
  final Contest contest;

  const RoundBreakdownTable({super.key, required this.contest});

  @override
  Widget build(BuildContext context) {
    final entries = contest.entries;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: NeoColors.nsmqBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(NeoBorders.sm),
                topRight: Radius.circular(NeoBorders.sm),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.table_chart_outlined, color: NeoColors.textLight, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ROUND-BY-ROUND BREAKDOWN',
                    style: NeoTypography.headingMedium(color: NeoColors.textLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // School Names Column Headers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: NeoColors.surfaceMuted,
              border: Border(bottom: BorderSide(color: NeoColors.border, width: 1)),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text('ROUND & RULES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                for (final entry in entries)
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.school.shortName.isNotEmpty
                          ? entry.school.shortName
                          : entry.school.name,
                      style: NeoTypography.badge(),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          // Round 1
          _buildRoundRow(
            title: NsmqConstants.round1Name,
            rules: '+3 direct, +1 bonus',
            roundNumber: 1,
            scores: entries.map((e) => e.scores.r1).toList(),
          ),
          const Divider(height: 1, color: NeoColors.neutralMuted),

          // Round 2
          _buildRoundRow(
            title: NsmqConstants.round2Name,
            rules: '+3 correct, -1 penalty',
            roundNumber: 2,
            scores: entries.map((e) => e.scores.r2).toList(),
          ),
          const Divider(height: 1, color: NeoColors.neutralMuted),

          // Round 3
          _buildRoundRow(
            title: NsmqConstants.round3Name,
            rules: 'Max 10 points (Special)',
            roundNumber: 3,
            isSpecial: true,
            scores: entries.map((e) => e.scores.r3).toList(),
          ),
          const Divider(height: 1, color: NeoColors.neutralMuted),

          // Round 4
          _buildRoundRow(
            title: NsmqConstants.round4Name,
            rules: '+2 correct, -1 penalty',
            roundNumber: 4,
            scores: entries.map((e) => e.scores.r4).toList(),
          ),
          const Divider(height: 1, color: NeoColors.neutralMuted),

          // Round 5
          _buildRoundRow(
            title: NsmqConstants.round5Name,
            rules: 'Riddles (5, 4, 3 pts)',
            roundNumber: 5,
            scores: entries.map((e) => e.scores.r5).toList(),
          ),
          const Divider(height: 2, color: NeoColors.border),

          // Total Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(
              color: NeoColors.surfaceYellow,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(NeoBorders.sm),
                bottomRight: Radius.circular(NeoBorders.sm),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    'TOTAL POINTS',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                for (final entry in entries)
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${entry.scores.total}',
                      style: NeoTypography.scoreText(
                        color: (contest.status != ContestStatus.scheduled &&
                                contest.isSchoolLeader(entry.school.id))
                            ? NeoColors.nsmqRed
                            : NeoColors.textPrimary,
                        size: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundRow({
    required String title,
    required String rules,
    required int roundNumber,
    required List<int> scores,
    bool isSpecial = false,
  }) {
    final isCurrentRound = contest.status == ContestStatus.live && contest.currentRound == roundNumber;
    final maxScore = scores.reduce((a, b) => a > b ? a : b);

    return Container(
      color: isCurrentRound ? NeoColors.surfaceRed : (isSpecial ? NeoColors.surfaceBlue : Colors.transparent),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: NeoTypography.bodyBold(size: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentRound) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: NeoColors.nsmqBrightRed,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                Text(
                  rules,
                  style: NeoTypography.caption(color: NeoColors.textSecondary).copyWith(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          for (final score in scores)
            Expanded(
              flex: 2,
              child: Text(
                score > 0 ? '$score' : (roundNumber > contest.currentRound ? '-' : '0'),
                style: NeoTypography.scoreText(
                  color: (score == maxScore && score > 0) ? NeoColors.nsmqRed : NeoColors.textPrimary,
                  size: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
