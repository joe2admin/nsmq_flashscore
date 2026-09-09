import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/neo_app_bar.dart';
import '../../../../core/widgets/neo_empty_state.dart';
import '../../../../core/widgets/school_badge_avatar.dart';
import 'package:nsmq_flashscore/features/live_scores/presentation/widgets/nsmq_match_card.dart';
import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: const NeoAppBar(
        title: 'MY FAVORITES',
        subtitle: 'PINNED SCHOOLS & MATCH ALERTS',
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: NeoColors.nsmqRed),
          );
        }

        if (controller.favoriteSchools.isEmpty) {
          return NeoEmptyState(
            icon: Icons.star_border,
            title: 'No Favorite Schools Pinned',
            message: 'Star schools from the Schools Directory to receive live updates, buzzer alerts, and score tracking.',
            actionText: 'Explore Schools',
            onAction: () {
              // Switch to Schools Tab
              Get.until((route) => route.isFirst);
            },
          );
        }

        return RefreshIndicator(
          color: NeoColors.nsmqRed,
          onRefresh: controller.refreshFavorites,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            children: [
            // Pinned Schools Header
            Row(
              children: [
                const Icon(Icons.school, color: NeoColors.nsmqRed, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'MY PINNED SCHOOLS',
                    style: NeoTypography.headingMedium(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Horizontal Pinned Schools Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.favoriteSchools.map((profile) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      borderRadius: NeoBorders.radiusSm,
                      border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                      boxShadow: NeoShadows.pill,
                    ),
                    child: Row(
                      children: [
                        SchoolBadgeAvatar(
                          crestUrl: profile.school.crestUrl,
                          schoolId: profile.school.id,
                          schoolName: profile.school.shortName.isNotEmpty
                              ? profile.school.shortName
                              : profile.school.name,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          profile.school.shortName.isNotEmpty
                              ? profile.school.shortName
                              : profile.school.name,
                          style: NeoTypography.bodyBold(size: 12),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => controller.removeFavorite(profile.school.id),
                          child: const Icon(Icons.close, size: 16, color: NeoColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Notification Preferences Card
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
                        const Icon(Icons.notifications_active, color: NeoColors.textLight, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'FLASHSCORE ALERTS PREFERENCES',
                            style: NeoTypography.headingMedium(color: NeoColors.textLight),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          title: 'Live Round Score Updates',
                          subtitle: 'Alert immediately when a round concludes',
                          value: controller.alertLiveRounds,
                          onChanged: (v) => controller.updatePreference(liveRounds: v),
                        ),
                        const Divider(height: 12, color: NeoColors.neutralMuted),
                        _buildSwitchTile(
                          title: 'Problem of the Day Released',
                          subtitle: 'Receive notification when Round 3 questions drop',
                          value: controller.alertProblemOfDay,
                          onChanged: (v) => controller.updatePreference(problemOfDay: v),
                        ),
                        const Divider(height: 12, color: NeoColors.neutralMuted),
                        _buildSwitchTile(
                          title: 'Final Match Verdict',
                          subtitle: 'Immediate broadcast of winning school & scores',
                          value: controller.alertFinalScores,
                          onChanged: (v) => controller.updatePreference(finalScores: v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Matches involving user's favorite schools
            Row(
              children: [
                const Icon(Icons.emoji_events, color: NeoColors.gold, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'SCHEDULED & LIVE MATCHES',
                    style: NeoTypography.headingMedium(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (controller.favoriteMatches.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: NeoColors.surfaceMuted,
                  borderRadius: NeoBorders.radiusSm,
                  border: Border.all(color: NeoColors.border, width: 1),
                ),
                child: Center(
                  child: Text(
                    'No active or scheduled matches found for your pinned schools today.',
                    style: NeoTypography.bodyRegular(),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...controller.favoriteMatches.map((contest) {
                return NsmqMatchCard(
                  contest: contest,
                  onTap: () {
                    Get.toNamed(AppRoutes.contestDetail, arguments: contest);
                  },
                );
              }),
          ],
        ),
      );
    }),
  );
}

Widget _buildSwitchTile({
  required String title,
  required String subtitle,
  required RxBool value,
  ValueChanged<bool>? onChanged,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: NeoTypography.bodyBold(size: 13)),
            Text(subtitle, style: NeoTypography.caption(color: NeoColors.textSecondary)),
          ],
        ),
      ),
      Obx(() => Switch(
            value: value.value,
            onChanged: (v) {
              value.value = v;
              onChanged?.call(v);
            },
            activeThumbColor: NeoColors.nsmqRed,
            activeTrackColor: NeoColors.surfaceRed,
          )),
    ],
  );
}
}
