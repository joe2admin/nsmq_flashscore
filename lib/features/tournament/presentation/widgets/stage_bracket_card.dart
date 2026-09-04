import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/neo_badge.dart';
import '../../../../core/widgets/school_badge_avatar.dart';
import '../../domain/entities/tournament_stage.dart';

class StageBracketCard extends StatelessWidget {
  final StageContestPreview contest;
  final VoidCallback? onTap;
  final bool isPreliminary;
  final bool isGrandFinale;
  final bool hasIncomingStub;

  const StageBracketCard({
    super.key,
    required this.contest,
    this.onTap,
    this.isPreliminary = false,
    this.isGrandFinale = false,
    this.hasIncomingStub = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isGrandFinale ? 0 : 12),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: isGrandFinale ? NeoBorders.radiusLg : NeoBorders.radiusMd,
        border: Border.all(
          color: NeoColors.border,
          width: isGrandFinale ? NeoBorders.strokeThick : NeoBorders.strokeDefault,
        ),
        boxShadow: isGrandFinale ? NeoShadows.card : NeoShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: isGrandFinale ? NeoBorders.radiusLg : NeoBorders.radiusMd,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isGrandFinale ? 16.0 : 12.0,
              vertical: isGrandFinale ? 18.0 : 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Match Label & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isGrandFinale ? 10 : 8,
                          vertical: isGrandFinale ? 5 : 3,
                        ),
                        decoration: BoxDecoration(
                          color: isGrandFinale ? NeoColors.surfaceYellow : NeoColors.surfaceBlue,
                          borderRadius: NeoBorders.radiusSm,
                          border: Border.all(color: NeoColors.border, width: 1.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isGrandFinale) ...[
                              const Icon(
                                Icons.emoji_events,
                                size: 14,
                                color: NeoColors.textPrimary,
                              ),
                              const SizedBox(width: 5),
                            ],
                            Flexible(
                              child: Text(
                                contest.displayLabel,
                                style: NeoTypography.badge(
                                  color: isGrandFinale ? NeoColors.textPrimary : NeoColors.nsmqBlue,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(),
                  ],
                ),
                SizedBox(height: isGrandFinale ? 16 : 10),

                // 3 School Rows (Bigger and more spacious on Grand Finale)
                for (int i = 0; i < contest.schoolNames.length; i++) ...[
                  _buildParticipantRow(i),
                  if (i < contest.schoolNames.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isGrandFinale ? 10.0 : 4.0),
                      child: const Divider(color: NeoColors.neutralMuted, height: 1),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantRow(int index) {
    final schoolName = contest.schoolNames[index];
    final score = index < contest.scores.length ? contest.scores[index] : 0;
    final isUpcoming = contest.status.toLowerCase() == 'upcoming';
    final isWinner = !isUpcoming && contest.winner != null && contest.winner == schoolName;

    return Row(
      children: [
        // School Avatar (or logo fallback)
        SchoolBadgeAvatar(
          schoolName: schoolName,
          size: isGrandFinale ? 30 : 22,
          isCircle: true,
          isLeader: isWinner,
        ),
        SizedBox(width: isGrandFinale ? 10 : 8),

        // School Name - Reduced size without ellipsis on Grand Finale
        Expanded(
          child: Text(
            schoolName,
            style: isGrandFinale
                ? GoogleFonts.archivoBlack(
                    fontSize: 13.0,
                    height: 1.25,
                    color: isWinner ? NeoColors.nsmqRed : NeoColors.textPrimary,
                  )
                : NeoTypography.headingMedium(
                    color: isWinner ? NeoColors.nsmqRed : NeoColors.textPrimary,
                  ),
            maxLines: isGrandFinale ? 2 : 1,
            softWrap: true,
            overflow: isGrandFinale ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),

        // Score Pill - More prominent on Grand Finale
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isGrandFinale ? 12 : 8,
            vertical: isGrandFinale ? 6 : 2,
          ),
          decoration: BoxDecoration(
            color: isWinner ? NeoColors.gold : NeoColors.surfaceMuted,
            borderRadius: NeoBorders.radiusSm,
            border: Border.all(color: NeoColors.border, width: isGrandFinale ? 1.5 : 1),
          ),
          child: Text(
            isUpcoming ? '-' : '$score',
            style: NeoTypography.scoreText(
              color: NeoColors.textPrimary,
              size: isGrandFinale ? 16 : 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    switch (contest.status.toLowerCase()) {
      case 'live':
        return NeoBadge.live(text: 'LIVE NOW');
      case 'finished':
        return NeoBadge.finished();
      default:
        return const NeoBadge(
          text: 'UPCOMING',
          backgroundColor: NeoColors.neutralMuted,
          textColor: NeoColors.textPrimary,
        );
    }
  }
}
