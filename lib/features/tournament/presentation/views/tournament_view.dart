import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../shell/presentation/controllers/navigation_controller.dart';
import '../../domain/entities/tournament_stage.dart';
import '../controllers/tournament_controller.dart';
import '../widgets/stage_bracket_card.dart';
import '../widgets/tournament_bracket_connectors.dart';
import '../widgets/trophy_champion_widget.dart';
import '../widgets/nsmq_history_sheet.dart';

class TournamentView extends GetView<TournamentController> {
  const TournamentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: NeoColors.nsmqRed),
            );
          }

          final stages = controller.stages;
          if (stages.isEmpty) {
            return const Center(child: Text('No tournament stages found'));
          }

          final activeIndex = controller.selectedStageIndex.value;

          return Column(
            children: [
              // 1. Top App Bar: < NSMQ TOURNAMENT
              _buildTopBar(context),

              // 2. Stage Navigation Pills Bar
              _buildStageSelector(stages, activeIndex),

              // 3. Main Stage Content (Horizontal PageView)
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.totalPages,
                  itemBuilder: (context, index) {
                    if (index == stages.length) {
                      return _buildTrophyPage(context, stages.lastOrNull);
                    }
                    final stage = stages[index];
                    if (stage.id == 'stage_finale') {
                      return _buildGrandFinalePage(context, stage);
                    }
                    return _buildStagePage(context, stage, index, controller.totalPages);
                  },
                ),
              ),

              // 4. Bottom Stage Dots Indicator & Swipe Gesture Hint
              _buildBottomControls(controller.totalPages, activeIndex),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: NeoColors.background,
        border: Border(
          bottom: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
        ),
      ),
      child: Row(
        children: [
          // Back Button: Pops if modal, else navigates to Tab 0 (Contests)
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else if (Get.isRegistered<NavigationController>()) {
                Get.find<NavigationController>().changePage(0);
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: NeoBorders.radiusSm,
                border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                boxShadow: NeoShadows.pill,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: NeoColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Centered Title: NSMQ TOURNAMENT
          Expanded(
            child: Center(
              child: Text(
                'NSMQ TOURNAMENT',
                style: NeoTypography.headingLarge(color: NeoColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // NSMQ History & Mistresses Archive Button
          GestureDetector(
            onTap: () => NsmqHistorySheet.show(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: NeoColors.gold,
                borderRadius: NeoBorders.radiusSm,
                border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                boxShadow: NeoShadows.pill,
              ),
              child: const Icon(
                Icons.auto_stories,
                size: 18,
                color: NeoColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageSelector(List<TournamentStage> stages, int activeIndex) {
    final trophyIndex = stages.length;
    final isTrophySelected = activeIndex == trophyIndex;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: const BoxDecoration(
        color: NeoColors.surface,
        border: Border(
          bottom: BorderSide(color: NeoColors.border, width: 1.5),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...stages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              final isSelected = index == activeIndex;

              return GestureDetector(
                onTap: () => controller.selectStage(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? NeoColors.nsmqRed : NeoColors.surface,
                    borderRadius: NeoBorders.radiusSm,
                    border: Border.all(
                      color: NeoColors.border,
                      width: NeoBorders.strokeDefault,
                    ),
                    boxShadow: NeoShadows.pill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (stage.isCurrent) ...[
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? NeoColors.gold : NeoColors.nsmqBrightRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      Text(
                        stage.name.toUpperCase(),
                        style: NeoTypography.badge(
                          color: isSelected ? NeoColors.textLight : NeoColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            // 6th Pill: THE TROPHY / THE CUP
            GestureDetector(
              onTap: () => controller.selectStage(trophyIndex),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isTrophySelected ? NeoColors.nsmqRed : NeoColors.surface,
                  borderRadius: NeoBorders.radiusSm,
                  border: Border.all(
                    color: NeoColors.border,
                    width: NeoBorders.strokeDefault,
                  ),
                  boxShadow: NeoShadows.pill,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 14,
                      color: isTrophySelected ? NeoColors.gold : NeoColors.nsmqRed,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'THE TROPHY',
                      style: NeoTypography.badge(
                        color: isTrophySelected ? NeoColors.textLight : NeoColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrandFinalePage(BuildContext context, TournamentStage stage) {
    final contest = stage.contests.firstOrNull;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Stage Title
                  Text(
                    stage.name.toUpperCase(),
                    style: NeoTypography.headingLarge(color: NeoColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    stage.subtitle.toUpperCase(),
                    style: NeoTypography.caption(color: NeoColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),

                  // Grand Finale Match Card (Enlarged vertical height, centered in page)
                  if (contest != null)
                    BracketStageGroup(
                      contests: [contest],
                      isGrandFinale: true,
                      showIncomingConnectors: true,
                      showOutgoingConnectors: true,
                      onContestTap: (c) => Get.toNamed(AppRoutes.contestDetail, arguments: c.id),
                    ),

                  const SizedBox(height: 16),

                  // Neo-brutalist swipe prompt cue
                  GestureDetector(
                    onTap: () => controller.selectStage(5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: NeoColors.surfaceYellow,
                        borderRadius: NeoBorders.radiusPill,
                        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                        boxShadow: NeoShadows.pill,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'SWIPE FOR THE TROPHY',
                            style: NeoTypography.badge(color: NeoColors.textPrimary),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: NeoColors.textPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrophyPage(BuildContext context, TournamentStage? finaleStage) {
    final contest = finaleStage?.contests.firstOrNull;
    final hasFinished = contest != null && contest.status.toLowerCase() != 'upcoming';
    final winner = hasFinished ? contest.winner : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'THE TROPHY',
                    style: NeoTypography.headingLarge(color: NeoColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NATIONAL SCIENCE & MATHS QUIZ',
                    style: NeoTypography.caption(color: NeoColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Trophy & Champion Widget featuring the exact user-provided trophy picture
                  TrophyChampionWidget(
                    championSchool: winner,
                    titles: '8-TIME CHAMPIONS',
                    onTap: () {
                      if (winner != null) {
                        Get.toNamed(AppRoutes.schoolDetail, arguments: 'sch_presec');
                      }
                    },
                  ),
                  const SizedBox(height: 8),

                  // View past winners action
                  GestureDetector(
                    onTap: () => NsmqHistorySheet.show(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: NeoColors.surface,
                        borderRadius: NeoBorders.radiusPill,
                        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                        boxShadow: NeoShadows.pill,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_stories,
                            size: 14,
                            color: NeoColors.nsmqRed,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'VIEW ALL PAST CHAMPIONS',
                            style: NeoTypography.badge(color: NeoColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStagePage(
    BuildContext context,
    TournamentStage stage,
    int stageIndex,
    int totalStages,
  ) {
    final isPrelims = stage.id == 'stage_prelims';
    final isOneEighth = stage.id == 'stage_one_eighth';
    final isQuarters = stage.id == 'stage_quarters';
    final isSemis = stage.id == 'stage_semis';

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      children: [
        // Stage Title (e.g. PRELIMINARY ROUND, QUARTER FINALS, etc.)
        Center(
          child: Text(
            stage.name.toUpperCase(),
            style: NeoTypography.headingLarge(color: NeoColors.textPrimary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 2),

        // Subtitle: 3 PARTICIPANTS PER MATCH
        Center(
          child: Text(
            stage.subtitle.toUpperCase(),
            style: NeoTypography.caption(color: NeoColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 14),

        // Contests layout according to tournament stage
        if (isPrelims || isOneEighth) ...[
          // Standard cards list with circle indicators for prelims
          ...stage.contests.map((contest) {
            return StageBracketCard(
              contest: contest,
              isPreliminary: isPrelims,
              onTap: () => Get.toNamed(AppRoutes.contestDetail, arguments: contest.id),
            );
          }),
        ] else if (isQuarters) ...[
          // Groups of 3 contests with right-side bracket branching into semi-finals
          _buildGroupedContests(
            contests: stage.contests,
            groupSize: 3,
            showOutgoingConnectors: true,
            showIncomingConnectors: false,
          ),
        ] else if (isSemis) ...[
          // Semi-final contests with left incoming feeder stub and right outgoing branch into Grand Finale
          _buildGroupedContests(
            contests: stage.contests,
            groupSize: 3,
            showOutgoingConnectors: true,
            showIncomingConnectors: true,
          ),
        ],

        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildGroupedContests({
    required List<StageContestPreview> contests,
    required int groupSize,
    required bool showOutgoingConnectors,
    required bool showIncomingConnectors,
  }) {
    final groups = <List<StageContestPreview>>[];
    for (int i = 0; i < contests.length; i += groupSize) {
      final end = (i + groupSize < contests.length) ? i + groupSize : contests.length;
      groups.add(contests.sublist(i, end));
    }

    return Column(
      children: groups.map((group) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: BracketStageGroup(
            contests: group,
            showOutgoingConnectors: showOutgoingConnectors,
            showIncomingConnectors: showIncomingConnectors,
            onContestTap: (contest) {
              Get.toNamed(AppRoutes.contestDetail, arguments: contest.id);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomControls(int totalStages, int activeIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        color: NeoColors.background,
        border: Border(
          top: BorderSide(color: NeoColors.border, width: 1.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalStages, (index) {
              final isCurrent = index == activeIndex;
              return GestureDetector(
                onTap: () => controller.selectStage(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: isCurrent ? 20.0 : 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: isCurrent ? NeoColors.nsmqRed : NeoColors.surface,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: NeoColors.border, width: 1.2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),

          // Horizontal Swipe Guidance
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.swap_horiz,
                size: 16,
                color: NeoColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Swipe horizontally to navigate through the tournament stages',
                  style: NeoTypography.caption(color: NeoColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
