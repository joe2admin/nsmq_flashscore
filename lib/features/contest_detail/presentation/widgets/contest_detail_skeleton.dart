import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../core/widgets/neo_skeleton.dart';

/// Skeleton placeholder for ContestDetailView.
/// Replicates the scoreboard hero card, audio placeholder, tab bar, and round breakdown table.
class ContestDetailSkeleton extends StatelessWidget {
  const ContestDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NeoSkeletonShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            // 1. Scoreboard Header Card Skeleton
            _buildHeaderCardSkeleton(),

            // 2. Audio Broadcast Player placeholder
            _buildAudioCardSkeleton(),

            // 3. Tab Bar Skeleton
            _buildTabBarSkeleton(),

            const SizedBox(height: 16),

            // 4. Round Breakdown Table Skeleton
            _buildTableSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCardSkeleton() {
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
            child: const Row(
              children: [
                Expanded(child: NeoSkeletonBone.line(height: 14)),
                SizedBox(width: 12),
                NeoSkeletonBone.badge(width: 60, height: 20),
              ],
            ),
          ),

          // 3-School Columns Scoreboard
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Row(
              children: [
                for (int i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                      decoration: BoxDecoration(
                        color: NeoColors.background,
                        borderRadius: NeoBorders.radiusSm,
                        border: Border.all(color: NeoColors.border, width: 1.5),
                      ),
                      child: const Column(
                        children: [
                          NeoSkeletonBone.circle(size: 42),
                          SizedBox(height: 8),
                          NeoSkeletonBone.line(width: 50, height: 12),
                          SizedBox(height: 10),
                          NeoSkeletonBone(
                            width: 44,
                            height: 32,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioCardSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: const Row(
        children: [
          NeoSkeletonBone.circle(size: 36),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeoSkeletonBone.line(width: 130, height: 14),
                SizedBox(height: 4),
                NeoSkeletonBone.line(width: 80, height: 10),
              ],
            ),
          ),
          NeoSkeletonBone.badge(width: 50, height: 22),
        ],
      ),
    );
  }

  Widget _buildTabBarSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          for (int i = 0; i < 4; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            const Expanded(
              child: NeoSkeletonBone(
                height: 36,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Column(
        children: [
          // Table header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NeoSkeletonBone.line(width: 70, height: 14),
              NeoSkeletonBone.line(width: 45, height: 14),
              NeoSkeletonBone.line(width: 45, height: 14),
              NeoSkeletonBone.line(width: 45, height: 14),
            ],
          ),
          const Divider(color: NeoColors.border, thickness: 1.5, height: 20),

          // 5 Round Rows
          for (int r = 1; r <= 5; r++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NeoSkeletonBone.line(width: 80, height: 12),
                  const NeoSkeletonBone(width: 30, height: 20),
                  const NeoSkeletonBone(width: 30, height: 20),
                  const NeoSkeletonBone(width: 30, height: 20),
                ],
              ),
            ),
            if (r < 5) const Divider(color: NeoColors.neutralMuted, height: 12),
          ],
        ],
      ),
    );
  }
}
