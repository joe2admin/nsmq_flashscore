import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/neo_app_bar.dart';
import '../../../../core/widgets/neo_empty_state.dart';
import '../../../../core/widgets/neo_search_bar.dart';
import '../controllers/schools_controller.dart';
import '../widgets/school_tile_card.dart';
import '../widgets/schools_directory_skeleton.dart';

class SchoolsDirectoryView extends GetView<SchoolsController> {
  const SchoolsDirectoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: const NeoAppBar(
        title: 'SCHOOL DIRECTORY',
        subtitle: 'NATIONAL POWERHOUSES & RANKINGS',
      ),
      body: Column(
        children: [
          // Search Input
          NeoSearchBar(
            hintText: 'Search school or city (e.g. Mfantsipim, Legon)...',
            onChanged: controller.updateSearch,
          ),

          // Filters row: Regions + Champions Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                // Champions Toggle Button
                Obx(() {
                  final isOnlyChamps = controller.onlyChampions.value;
                  return GestureDetector(
                    onTap: controller.toggleOnlyChampions,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isOnlyChamps ? NeoColors.gold : NeoColors.surface,
                        borderRadius: NeoBorders.radiusSm,
                        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                        boxShadow: NeoShadows.pill,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_events, size: 14, color: NeoColors.textPrimary),
                          const SizedBox(width: 4),
                          Text(
                            'CHAMPIONS',
                            style: NeoTypography.badge(color: NeoColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(width: 8),

                // Region Chips
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.regions.map((region) {
                        return Obx(() {
                          final isSelected = controller.selectedRegion.value == region;
                          return GestureDetector(
                            onTap: () => controller.selectRegion(region),
                            child: Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? NeoColors.nsmqBlue : NeoColors.surfaceMuted,
                                borderRadius: NeoBorders.radiusSm,
                                border: Border.all(color: NeoColors.border, width: NeoBorders.strokeThin),
                              ),
                              child: Text(
                                region.toUpperCase(),
                                style: NeoTypography.badge(
                                  color: isSelected ? NeoColors.textLight : NeoColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // School List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const SchoolsDirectorySkeleton();
              }

              if (controller.schools.isEmpty) {
                return NeoEmptyState(
                  icon: Icons.school_outlined,
                  title: 'No Schools Found',
                  message: 'No school matches your current search and filter settings.',
                  actionText: 'Reset Filters',
                  onAction: () {
                    controller.selectRegion('All Regions');
                    if (controller.onlyChampions.value) controller.toggleOnlyChampions();
                    controller.updateSearch('');
                  },
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                itemCount: controller.schools.length,
                itemBuilder: (context, index) {
                  final profile = controller.schools[index];
                  return SchoolTileCard(
                    profile: profile,
                    onTap: () {
                      Get.toNamed(AppRoutes.schoolDetail, arguments: profile);
                    },
                    onFavoriteTap: () {
                      controller.toggleFavorite(profile.school.id);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
