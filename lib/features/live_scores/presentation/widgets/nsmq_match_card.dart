import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/neo_badge.dart';
import '../../../../core/widgets/neo_folder_card.dart';
import '../../../../core/widgets/school_badge_avatar.dart';
import '../../domain/entities/contest.dart';

/// Flashscore-style Match Card tailored for 3-School NSMQ Contests.
/// Employs official NSMQ colors (Red & Blue) in Neo-Brutalist styling.
/// Fully responsive and overflow-proof on all mobile screen widths.
class NsmqMatchCard extends StatelessWidget {
  final Contest contest;
  final VoidCallback? onTap;

  const NsmqMatchCard({
    super.key,
    required this.contest,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final leaderSchoolId = contest.leader?.school.id;

    Color tabColor = NeoColors.nsmqBlue;
    if (contest.status == ContestStatus.live) {
      tabColor = NeoColors.nsmqBlue;
    } else if (contest.status == ContestStatus.finished) {
      tabColor = NeoColors.neutralMuted;
    } else {
      tabColor = NeoColors.surfaceBlue;
    }

    return NeoFolderCard(
      tabText: '${contest.title} • ${contest.stage}',
      tabIcon: Icons.emoji_events_outlined,
      tabColor: tabColor,
      onTap: onTap,
      trailingBadge: _buildStatusBadge(),
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3-School Scoreboard Rows
          for (int i = 0; i < contest.entries.length; i++) ...[
            _buildSchoolRow(
              contest.entries[i],
              isLeader: contest.entries[i].school.id == leaderSchoolId,
            ),
            if (i < contest.entries.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: NeoColors.border, thickness: 1.5),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    switch (contest.status) {
      case ContestStatus.live:
        return NeoBadge.live(text: 'R${contest.currentRound} LIVE');
      case ContestStatus.finished:
        return NeoBadge.finished();
      case ContestStatus.scheduled:
        return const NeoBadge(
          text: 'UPCOMING',
          backgroundColor: NeoColors.neutralMuted,
          textColor: NeoColors.textPrimary,
        );
    }
  }

  Widget _buildSchoolRow(ContestantEntry entry, {required bool isLeader}) {
    // Prefer shortName if present (e.g. PRESEC, BOTWEY, PREMPEH), fallback to full name
    final displayName = entry.school.shortName.isNotEmpty
        ? entry.school.shortName.toUpperCase()
        : entry.school.name.toUpperCase();

    return Row(
      children: [
        // School Crest Badge Avatar (Fixed 28x28 with leader overlay)
        Stack(
          clipBehavior: Clip.none,
          children: [
            SchoolBadgeAvatar(
              crestUrl: entry.school.crestUrl,
              schoolId: entry.school.id,
              schoolName: entry.school.shortName.isNotEmpty
                  ? entry.school.shortName
                  : entry.school.name,
              size: 28,
              isLeader: isLeader,
            ),
            if (isLeader)
              Positioned(
                right: -3,
                top: -3,
                child: Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: const BoxDecoration(
                    color: NeoColors.gold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events, size: 9, color: NeoColors.textPrimary),
                ),
              ),
          ],
        ),

        const SizedBox(width: 8),

        // School Name & Region (Takes remaining available width with ellipsis)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayName,
                style: NeoTypography.headingMedium(color: NeoColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                entry.school.region,
                style: NeoTypography.caption(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 6),

        // Round Mini-Scores (Fixed 5-round pills)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRoundPill(entry.scores.r1),
            const SizedBox(width: 2),
            _buildRoundPill(entry.scores.r2),
            const SizedBox(width: 2),
            _buildRoundPill(entry.scores.r3, isSpecial: true),
            const SizedBox(width: 2),
            _buildRoundPill(entry.scores.r4),
            const SizedBox(width: 2),
            _buildRoundPill(entry.scores.r5),
          ],
        ),

        const SizedBox(width: 8),

        // Total Score Block (Fixed 38x28)
        Container(
          width: 38,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isLeader ? NeoColors.gold : NeoColors.surface,
            borderRadius: NeoBorders.radiusSm,
            border: Border.all(color: NeoColors.border, width: NeoBorders.strokeThin),
            boxShadow: isLeader ? NeoShadows.pill : null,
          ),
          child: Text(
            '${entry.scores.total}',
            textAlign: TextAlign.center,
            style: NeoTypography.scoreText(
              color: NeoColors.textPrimary,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoundPill(int score, {bool isSpecial = false}) {
    final bool hasScore = score > 0;
    return Container(
      width: 20,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSpecial && hasScore ? NeoColors.surfaceBlue : NeoColors.surfaceMuted,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSpecial && hasScore
              ? NeoColors.nsmqElectricBlue.withValues(alpha: 0.5)
              : NeoColors.border.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Text(
        hasScore ? '$score' : '-',
        style: NeoTypography.caption(color: NeoColors.textPrimary).copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 9.5,
        ),
      ),
    );
  }
}
