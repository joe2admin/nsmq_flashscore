import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../core/widgets/neo_skeleton.dart';

/// Skeleton placeholder for the School Detail view.
/// Matches the Hero Card, Historical Records Card, and Contestants sections.
class SchoolDetailSkeleton extends StatelessWidget {
  const SchoolDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NeoSkeletonShimmer(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // 1. Hero Card Skeleton
          _buildHeroCardSkeleton(),

          const SizedBox(height: 16),

          // 2. Records Card Skeleton
          _buildRecordsCardSkeleton(),

          const SizedBox(height: 16),

          // 3. Notable Contestants Skeleton
          _buildContestantsCardSkeleton(),
        ],
      ),
    );
  }

  Widget _buildHeroCardSkeleton() {
    return Container(
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
          const Row(
            children: [
              NeoSkeletonBone.circle(size: 64),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NeoSkeletonBone.line(height: 18),
                    SizedBox(height: 8),
                    NeoSkeletonBone.line(width: 140, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: NeoColors.surfaceMuted,
              borderRadius: NeoBorders.radiusSm,
              border: Border.all(color: NeoColors.border, width: 1),
            ),
            child: const NeoSkeletonBone.line(width: 220, height: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Column(
        children: [
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
                NeoSkeletonBone.circle(size: 18),
                SizedBox(width: 8),
                NeoSkeletonBone.line(width: 150, height: 14),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                for (int i = 0; i < 3; i++) ...[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NeoSkeletonBone.line(width: 120, height: 13),
                      NeoSkeletonBone.line(width: 60, height: 13),
                    ],
                  ),
                  if (i < 2) const Divider(height: 16, color: NeoColors.neutralMuted),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContestantsCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeoSkeletonBone.line(width: 160, height: 15),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              NeoSkeletonBone.badge(width: 90, height: 26),
              NeoSkeletonBone.badge(width: 110, height: 26),
              NeoSkeletonBone.badge(width: 85, height: 26),
            ],
          ),
        ],
      ),
    );
  }
}
