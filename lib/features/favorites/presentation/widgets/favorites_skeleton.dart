import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../core/widgets/neo_skeleton.dart';

/// Skeleton placeholder for FavoritesView.
/// Replicates the pinned school chips row, notification preferences card, and match card.
class FavoritesSkeleton extends StatelessWidget {
  const FavoritesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NeoSkeletonShimmer(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // 1. Pinned Schools Header
          const Row(
            children: [
              NeoSkeletonBone.circle(size: 18),
              SizedBox(width: 8),
              NeoSkeletonBone.line(width: 140, height: 16),
            ],
          ),
          const SizedBox(height: 10),

          // Horizontal Pinned Schools Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                for (int i = 0; i < 3; i++) ...[
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      borderRadius: NeoBorders.radiusSm,
                      border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                      boxShadow: NeoShadows.pill,
                    ),
                    child: const Row(
                      children: [
                        NeoSkeletonBone.circle(size: 20),
                        SizedBox(width: 8),
                        NeoSkeletonBone.line(width: 60, height: 12),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Notification Preferences Card Skeleton
          Container(
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
                    color: NeoColors.nsmqBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(NeoBorders.sm),
                      topRight: Radius.circular(NeoBorders.sm),
                    ),
                  ),
                  child: const Row(
                    children: [
                      NeoSkeletonBone.circle(size: 18),
                      SizedBox(width: 8),
                      NeoSkeletonBone.line(width: 180, height: 14),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      for (int i = 0; i < 3; i++) ...[
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NeoSkeletonBone.line(width: 140, height: 13),
                                SizedBox(height: 4),
                                NeoSkeletonBone.line(width: 190, height: 10),
                              ],
                            ),
                            NeoSkeletonBone(width: 40, height: 22, borderRadius: BorderRadius.all(Radius.circular(11))),
                          ],
                        ),
                        if (i < 2) const Divider(height: 16, color: NeoColors.neutralMuted),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 3. Matches Header
          const Row(
            children: [
              NeoSkeletonBone.circle(size: 20),
              SizedBox(width: 8),
              NeoSkeletonBone.line(width: 160, height: 16),
            ],
          ),
          const SizedBox(height: 10),

          // Match card skeleton
          Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: NeoBorders.radiusMd,
              border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
              boxShadow: NeoShadows.card,
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NeoSkeletonBone.line(width: 120, height: 12),
                    NeoSkeletonBone.badge(width: 60, height: 20),
                  ],
                ),
                const SizedBox(height: 12),
                for (int i = 0; i < 3; i++) ...[
                  const Row(
                    children: [
                      NeoSkeletonBone.circle(size: 24),
                      SizedBox(width: 8),
                      Expanded(child: NeoSkeletonBone.line(height: 13)),
                      SizedBox(width: 8),
                      NeoSkeletonBone(width: 32, height: 22),
                    ],
                  ),
                  if (i < 2) const Divider(color: NeoColors.neutralMuted, height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
