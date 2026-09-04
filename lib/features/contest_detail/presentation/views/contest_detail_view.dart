import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/neo_app_bar.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';
import '../controllers/contest_detail_controller.dart';
import '../widgets/contest_header_card.dart';
import '../widgets/contest_live_audio_card.dart';
import '../widgets/contestants_card.dart';
import '../widgets/head_to_head_card.dart';
import '../widgets/round_breakdown_table.dart';

class ContestDetailView extends GetView<ContestDetailController> {
  const ContestDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: NeoAppBar(
        title: 'CONTEST DETAIL',
        subtitle: 'NSMQ 2026 OFFICIAL SCORECARD',
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: NeoBorders.radiusSm,
                border: Border.all(color: NeoColors.border, width: 2),
                boxShadow: NeoShadows.pill,
              ),
              child: const Icon(Icons.share, size: 18, color: NeoColors.textPrimary),
            ),
            onPressed: () {
              Get.snackbar(
                'Share Match',
                'Live scorecard link copied to clipboard!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: NeoColors.surface,
                colorText: NeoColors.textPrimary,
                borderColor: NeoColors.border,
                borderWidth: 2,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: NeoColors.nsmqRed),
          );
        }

        final detail = controller.contestDetail.value;
        if (detail == null) {
          return const Center(child: Text('Contest detail not found'));
        }

        return DefaultTabController(
          length: 4,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Top Scoreboard
                      ContestHeaderCard(detail: detail),

                      // Live Audio Broadcast (Only for Live Matches)
                      if (detail.contest.status == ContestStatus.live) ...[
                        const ContestLiveAudioCard(),
                        const SizedBox(height: 6),
                      ],
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: NeoColors.nsmqRed,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: NeoColors.border, width: 1.5),
                        boxShadow: NeoShadows.pill,
                      ),
                      dividerColor: Colors.transparent,
                      labelPadding: EdgeInsets.zero,
                      labelColor: NeoColors.textLight,
                      unselectedLabelColor: NeoColors.textSecondary,
                      splashBorderRadius: BorderRadius.circular(4),
                      labelStyle: NeoTypography.badge(color: NeoColors.textLight).copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                      unselectedLabelStyle: NeoTypography.badge(color: NeoColors.textSecondary).copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      tabs: const [
                        Tab(
                          height: 36,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('OVERVIEW'),
                            ),
                          ),
                        ),
                        Tab(
                          height: 36,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('ROUNDS'),
                            ),
                          ),
                        ),
                        Tab(
                          height: 36,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('LINEUPS'),
                            ),
                          ),
                        ),
                        Tab(
                          height: 36,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('H2H'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                    // Tab 1: Overview
                    ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        // Problem of the Day Spotlight
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: NeoColors.surfaceBlue,
                            borderRadius: NeoBorders.radiusMd,
                            border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                            boxShadow: NeoShadows.card,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.psychology, color: NeoColors.nsmqBlue, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'PROBLEM OF THE DAY (ROUND 3)',
                                      style: NeoTypography.headingMedium(color: NeoColors.nsmqBlue),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                detail.problemOfTheDaySummary,
                                style: NeoTypography.bodyRegular(color: NeoColors.textPrimary),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: NeoColors.surfaceYellow,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: NeoColors.border, width: 1),
                                ),
                                child: Text(
                                  'Prudential Life Award: GHS 2,000 for perfect 10 pts',
                                  style: NeoTypography.caption(color: NeoColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Condensed Round Table
                        RoundBreakdownTable(contest: detail.contest),
                      ],
                    ),

                    // Tab 2: Full Rounds Breakdown
                    ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        RoundBreakdownTable(contest: detail.contest),
                      ],
                    ),

                    // Tab 3: Lineups
                    ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        ContestantsCard(lineups: detail.lineups),
                      ],
                    ),

                    // Tab 4: Head to head
                    ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        HeadToHeadCard(matches: detail.headToHead),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      }
    }

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => 52.0;
  @override
  double get maxExtent => 52.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: NeoColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          color: NeoColors.surface,
          borderRadius: NeoBorders.radiusSm,
          border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
          boxShadow: NeoShadows.pill,
        ),
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return oldDelegate._tabBar != _tabBar;
  }
}
