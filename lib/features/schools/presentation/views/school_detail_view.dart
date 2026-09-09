import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/neo_app_bar.dart';
import '../../../../core/widgets/school_badge_avatar.dart';
import 'package:nsmq_flashscore/features/live_scores/presentation/widgets/nsmq_match_card.dart';
import '../controllers/school_detail_controller.dart';

class SchoolDetailView extends GetView<SchoolDetailController> {
  const SchoolDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: NeoAppBar(
        title: 'SCHOOL PROFILE',
        subtitle: 'NSMQ ARCHIVE & RECORDS',
        actions: [
          Obx(() {
            final isFav = controller.profile.value?.isFavorite ?? false;
            return IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isFav ? NeoColors.gold : NeoColors.surface,
                  borderRadius: NeoBorders.radiusSm,
                  border: Border.all(color: NeoColors.border, width: 2),
                  boxShadow: NeoShadows.pill,
                ),
                child: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  size: 18,
                  color: NeoColors.textPrimary,
                ),
              ),
              onPressed: controller.toggleFavorite,
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: NeoColors.nsmqRed),
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('School profile not found'));
        }

        final school = profile.school;

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Hero Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: NeoBorders.radiusMd,
                border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                boxShadow: NeoShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SchoolBadgeAvatar(
                        crestUrl: school.crestUrl,
                        schoolId: school.id,
                        schoolName: school.name,
                        size: 64,
                        isLeader: school.titlesCount > 0,
                        showShadow: true,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              school.name.toUpperCase(),
                              style: NeoTypography.headingLarge(),
                            ),
                            Text(
                              '${profile.city} • ${school.region} • Est. ${profile.foundedYear}',
                              style: NeoTypography.caption(color: NeoColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: NeoColors.surfaceMuted,
                      borderRadius: NeoBorders.radiusSm,
                      border: Border.all(color: NeoColors.border, width: 1),
                    ),
                    child: Text(
                      'Motto: "${profile.motto}"',
                      style: NeoTypography.bodyMedium(color: NeoColors.textPrimary).copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Trophy Cabinet
            if (school.titlesCount > 0) ...[
              Container(
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
                          const Icon(Icons.emoji_events, color: NeoColors.textLight, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'TROPHY CABINET (${school.titlesCount} TITLES)',
                              style: NeoTypography.headingMedium(color: NeoColors.textLight),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: profile.championshipYears.map((year) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: NeoColors.surfaceYellow,
                              borderRadius: NeoBorders.radiusSm,
                              border: Border.all(color: NeoColors.border, width: 1.5),
                              boxShadow: NeoShadows.pill,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.emoji_events, size: 14, color: NeoColors.nsmqRed),
                                const SizedBox(width: 6),
                                Text(
                                  '$year CHAMPION',
                                  style: NeoTypography.badge(color: NeoColors.textPrimary),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Tournament Statistics Matrix
            Container(
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
                      color: NeoColors.nsmqBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(NeoBorders.sm),
                        topRight: Radius.circular(NeoBorders.sm),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.analytics_outlined, color: NeoColors.textLight, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'NSMQ HISTORICAL RECORDS',
                            style: NeoTypography.headingMedium(color: NeoColors.textLight),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        _buildStatRow('Finals Appearances', '${profile.finalsAppearances} times'),
                        const Divider(height: 16, color: NeoColors.neutralMuted),
                        _buildStatRow('Total Contests Won', '${profile.totalContestsWon} matches'),
                        const Divider(height: 16, color: NeoColors.neutralMuted),
                        _buildStatRow('All-Time High Score', profile.highestScoreRecord),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Notable Contestants
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: NeoBorders.radiusMd,
                border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                boxShadow: NeoShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEGENDARY CONTESTANTS',
                    style: NeoTypography.headingMedium(),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: profile.notableContestants.map((name) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: NeoColors.surfaceBlue,
                          borderRadius: NeoBorders.radiusSm,
                          border: Border.all(color: NeoColors.border, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 12, color: NeoColors.nsmqBlue),
                            const SizedBox(width: 4),
                            Text(name, style: NeoTypography.bodyBold(size: 12)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Contest Match History
            Obx(() {
              if (controller.matchHistory.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.history, color: NeoColors.nsmqRed, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'CONTEST HISTORY (${controller.matchHistory.length})',
                          style: NeoTypography.headingMedium(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...controller.matchHistory.map((contest) {
                    return NsmqMatchCard(
                      contest: contest,
                      onTap: () {
                        Get.toNamed(AppRoutes.contestDetail, arguments: contest);
                      },
                    );
                  }),
                ],
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: NeoTypography.bodyBold(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: NeoColors.surfaceMuted,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: NeoColors.border, width: 1),
          ),
          child: Text(
            value,
            style: NeoTypography.badge(color: NeoColors.nsmqRed),
          ),
        ),
      ],
    );
  }
}
