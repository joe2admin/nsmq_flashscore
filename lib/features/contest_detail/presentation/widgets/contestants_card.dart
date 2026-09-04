import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/school_badge_avatar.dart';
import 'package:nsmq_flashscore/features/contest_detail/domain/entities/contest_detail.dart';

class ContestantsCard extends StatelessWidget {
  final List<ContestantLineup> lineups;

  const ContestantsCard({super.key, required this.lineups});

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
              color: NeoColors.nsmqRed,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(NeoBorders.sm),
                topRight: Radius.circular(NeoBorders.sm),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.people_alt_outlined, color: NeoColors.textLight, size: 16),
                const SizedBox(width: 8),
                Text(
                  'CONTESTANTS & LINEUPS',
                  style: NeoTypography.headingMedium(color: NeoColors.textLight),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lineups.length,
            separatorBuilder: (_, _) => const Divider(height: 1, color: NeoColors.neutralMuted),
            itemBuilder: (context, index) {
              final lineup = lineups[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: NeoBorders.radiusSm,
                        onTap: () {
                          if (lineup.schoolId.isNotEmpty) {
                            Get.toNamed(
                              AppRoutes.schoolDetail,
                              arguments: lineup.schoolId,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              SchoolBadgeAvatar(
                                schoolId: lineup.schoolId,
                                schoolName: lineup.schoolName,
                                size: 26,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  lineup.schoolName.toUpperCase(),
                                  style: NeoTypography.headingMedium(color: NeoColors.nsmqBlue),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: NeoColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        for (final contestant in lineup.mainContestants)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: NeoColors.surfaceMuted,
                              borderRadius: NeoBorders.radiusSm,
                              border: Border.all(color: NeoColors.border, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.person, size: 12, color: NeoColors.textPrimary),
                                const SizedBox(width: 4),
                                Text(contestant, style: NeoTypography.bodyBold(size: 11)),
                              ],
                            ),
                          ),
                        if (lineup.reserveContestant != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: NeoColors.background,
                              borderRadius: NeoBorders.radiusSm,
                              border: Border.all(color: NeoColors.textSecondary, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.shield_outlined, size: 12, color: NeoColors.textSecondary),
                                const SizedBox(width: 4),
                                Text('${lineup.reserveContestant} (Sub)', style: NeoTypography.caption()),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if (lineup.patron != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Patron / Coach: ${lineup.patron}',
                        style: NeoTypography.caption(color: NeoColors.textSecondary),
                      ),
                    ],
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
