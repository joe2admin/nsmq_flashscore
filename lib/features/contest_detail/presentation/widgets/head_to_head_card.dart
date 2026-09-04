import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/school_badge_avatar.dart';
import 'package:nsmq_flashscore/features/contest_detail/domain/entities/contest_detail.dart';

class HeadToHeadCard extends StatelessWidget {
  final List<HeadToHeadMatch> matches;

  const HeadToHeadCard({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: NeoColors.darkCanvas,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(NeoBorders.sm),
                topRight: Radius.circular(NeoBorders.sm),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.history_edu, color: NeoColors.textLight, size: 16),
                const SizedBox(width: 8),
                Text(
                  'HEAD-TO-HEAD HISTORY',
                  style: NeoTypography.headingMedium(color: NeoColors.textLight),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: matches.length,
            separatorBuilder: (_, _) => const Divider(height: 1, color: NeoColors.neutralMuted),
            itemBuilder: (context, index) {
              final match = matches[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${match.year} • ${match.stage}',
                            style: NeoTypography.badge(color: NeoColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: NeoColors.surfaceYellow,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: NeoColors.border, width: 1),
                          ),
                          child: Text(
                            'WINNER: ${match.winnerSchoolName}',
                            style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 9),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: match.scores.entries.map((e) {
                        final isWinner = e.key == match.winnerSchoolName;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SchoolBadgeAvatar(
                              schoolName: e.key,
                              size: 16,
                              isLeader: isWinner,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${e.key}: ',
                              style: NeoTypography.bodyBold(
                                color: isWinner ? NeoColors.nsmqRed : NeoColors.textPrimary,
                                size: 12,
                              ),
                            ),
                            Text(
                              '${e.value} pts',
                              style: NeoTypography.bodyRegular(size: 12),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
