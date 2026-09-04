import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/tournament_stage.dart';

class AwardCard extends StatelessWidget {
  final TournamentAward award;

  const AwardCard({super.key, required this.award});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: NeoColors.nsmqBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(NeoBorders.sm),
                topRight: Radius.circular(NeoBorders.sm),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    award.title.toUpperCase(),
                    style: NeoTypography.badge(color: NeoColors.textLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: NeoColors.gold,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: NeoColors.border, width: 1),
                  ),
                  child: Text(
                    award.prize,
                    style: NeoTypography.badge(color: NeoColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: NeoColors.surfaceYellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: NeoColors.border, width: 1.5),
                  ),
                  child: const Icon(Icons.emoji_events, size: 20, color: NeoColors.nsmqRed),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        award.currentLeader,
                        style: NeoTypography.headingMedium(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Sponsor: ${award.sponsor}',
                        style: NeoTypography.caption(color: NeoColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: NeoColors.surfaceRed,
                    borderRadius: NeoBorders.radiusSm,
                    border: Border.all(color: NeoColors.border, width: 1),
                  ),
                  child: Text(
                    '${award.points} PTS',
                    style: NeoTypography.scoreText(color: NeoColors.nsmqRed, size: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
