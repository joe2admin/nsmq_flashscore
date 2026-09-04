import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/neo_app_bar.dart';
import '../../../../core/widgets/neo_empty_state.dart';
import '../../../../core/widgets/neo_search_bar.dart';
import '../controllers/live_scores_controller.dart';
import '../widgets/date_strip_selector.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/nsmq_match_card.dart';

class LiveScoresView extends GetView<LiveScoresController> {
  const LiveScoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: const NeoAppBar(
        title: 'NSMQ FLASHSCORE',
        subtitle: '2026 NATIONAL CHAMPIONSHIP',
      ),
      body: Column(
        children: [
          // Date Picker Strip
          Obx(() => DateStripSelector(
                selectedDate: controller.selectedDate.value,
                onDateSelected: controller.selectDate,
              )),

          // Search bar
          NeoSearchBar(
            onChanged: controller.updateSearch,
            hintText: 'Search schools (e.g. Presec, Prempeh)...',
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          ),

          // Status Filters
          Obx(() => FilterChipsRow(
                selectedStatus: controller.selectedStatus.value,
                liveCount: controller.liveCount,
                onStatusChanged: controller.selectStatus,
              )),

          // Contest Match List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: NeoColors.nsmqRed,
                    strokeWidth: 3,
                  ),
                );
              }

              if (controller.contests.isEmpty) {
                return NeoEmptyState(
                  icon: Icons.emoji_events_outlined,
                  title: 'No Contests Found',
                  message: 'There are no contests matching the selected date or filter criteria.',
                  actionText: 'Clear Filters',
                  onAction: () {
                    controller.selectStatus(null);
                    controller.selectStage('All Stages');
                    controller.updateSearch('');
                  },
                );
              }

              return RefreshIndicator(
                color: NeoColors.nsmqRed,
                onRefresh: controller.fetchContests,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: controller.contests.length,
                  itemBuilder: (context, index) {
                    final contest = controller.contests[index];
                    return NsmqMatchCard(
                      contest: contest,
                      onTap: () {
                        Get.toNamed(AppRoutes.contestDetail, arguments: contest);
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
