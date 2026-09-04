import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/neo_badge.dart';
import '../../../../core/widgets/school_badge_avatar.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';
import 'package:nsmq_flashscore/features/contest_detail/domain/entities/contest_detail.dart';

class ContestHeaderCard extends StatelessWidget {
  final ContestDetail detail;

  const ContestHeaderCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final contest = detail.contest;
    final isLive = contest.status == ContestStatus.live;
    final isFinished = contest.status == ContestStatus.finished;
    final isScheduled = contest.status == ContestStatus.scheduled;
    final maxScore = contest.highestScore;

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Column(
        children: [
          // Top Info Banner
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
                Expanded(
                  child: Text(
                    '${contest.title.toUpperCase()} • ${contest.stage.toUpperCase()}',
                    style: NeoTypography.badge(color: NeoColors.textLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusBadge(contest),
              ],
            ),
          ),

          // 3-School Main Scoreboard
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int idx = 0; idx < contest.entries.length; idx++) ...[
                    if (idx > 0) const SizedBox(width: 8),
                    Builder(
                      builder: (context) {
                        final entry = contest.entries[idx];
                        final hasHighestScore = contest.entries.isNotEmpty && entry.scores.total == maxScore;

                        // Determine tag text, icon, and card highlight
                        String? tagText;
                        bool isHighlighted = false;

                        if (isLive && hasHighestScore) {
                          tagText = 'LEADING';
                          isHighlighted = true;
                        } else if (isFinished && (hasHighestScore || entry.isWinner)) {
                          tagText = 'WINNER';
                          isHighlighted = true;
                        }

                        return Expanded(
                          child: Container(
                            key: Key('contest_school_card_$idx'),
                            decoration: BoxDecoration(
                              color: isHighlighted ? NeoColors.surfaceYellow : NeoColors.background,
                              borderRadius: NeoBorders.radiusSm,
                              border: Border.all(
                                color: isHighlighted ? NeoColors.nsmqRed : NeoColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: NeoBorders.radiusSm,
                                splashColor: NeoColors.nsmqRed.withValues(alpha: 0.12),
                                highlightColor: NeoColors.surfaceMuted,
                                onTap: () {
                                  if (entry.school.id.isNotEmpty) {
                                    Get.toNamed(
                                      AppRoutes.schoolDetail,
                                      arguments: entry.school.id,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (!isScheduled)
                                        Visibility(
                                          visible: tagText != null,
                                          maintainSize: true,
                                          maintainAnimation: true,
                                          maintainState: true,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            margin: const EdgeInsets.only(bottom: 6),
                                            decoration: BoxDecoration(
                                              color: NeoColors.gold,
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(color: NeoColors.border, width: 1),
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.emoji_events, size: 9, color: NeoColors.textPrimary),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    tagText ?? '',
                                                    style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 8.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SchoolBadgeAvatar(
                                            crestUrl: entry.school.crestUrl,
                                            schoolId: entry.school.id,
                                            schoolName: entry.school.shortName.isNotEmpty
                                                ? entry.school.shortName
                                                : entry.school.name,
                                            size: 44,
                                            isLeader: isHighlighted,
                                            showShadow: true,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            entry.school.shortName.isNotEmpty
                                                ? entry.school.shortName
                                                : entry.school.name,
                                            style: NeoTypography.headingMedium(),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            entry.school.region,
                                            style: NeoTypography.caption(color: NeoColors.textSecondary),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${entry.scores.total}',
                                            style: NeoTypography.displayLarge(
                                              color: isHighlighted ? NeoColors.nsmqRed : NeoColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'PTS',
                                            style: NeoTypography.badge(color: NeoColors.textSecondary).copyWith(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Meta Ticker (Current Round, Mistress, Venue)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: NeoColors.surfaceMuted,
              border: Border(
                top: BorderSide(color: NeoColors.border, width: NeoBorders.strokeThin),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(NeoBorders.sm),
                bottomRight: Radius.circular(NeoBorders.sm),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: NeoColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  flex: 3,
                  child: Text(
                    detail.venue,
                    style: NeoTypography.caption(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: Text(
                    detail.quizMistress,
                    style: NeoTypography.caption(color: NeoColors.nsmqBlue),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(Contest contest) {
    switch (contest.status) {
      case ContestStatus.live:
        return NeoBadge.live(text: 'R${contest.currentRound} LIVE');
      case ContestStatus.finished:
        return NeoBadge.finished();
      case ContestStatus.scheduled:
        return const NeoBadge(
          text: 'SCHEDULED',
          backgroundColor: NeoColors.neutralMuted,
          textColor: NeoColors.textPrimary,
        );
    }
  }
}
