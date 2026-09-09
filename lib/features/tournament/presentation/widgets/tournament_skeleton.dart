import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../core/widgets/neo_skeleton.dart';

/// Skeleton placeholder for TournamentView.
/// Replicates the stage navigation pills row and stage bracket cards.
class TournamentSkeleton extends StatelessWidget {
  const TournamentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NeoSkeletonShimmer(
      child: Column(
        children: [
          // 1. Stage Selector Pills Strip Skeleton
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: const BoxDecoration(
              color: NeoColors.background,
              border: Border(
                bottom: BorderSide(color: NeoColors.border, width: NeoBorders.strokeThin),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: [
                  for (int i = 0; i < 5; i++) ...[
                    NeoSkeletonBone.badge(
                      width: i == 0 ? 110 : 90,
                      height: 32,
                      borderRadius: NeoBorders.radiusSm,
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ),

          // 2. Stage Bracket Cards Skeleton List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBracketCardSkeleton(),
                const SizedBox(height: 12),
                _buildBracketCardSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBracketCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Match label & status
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NeoSkeletonBone.badge(width: 80, height: 20),
              NeoSkeletonBone.badge(width: 55, height: 20),
            ],
          ),

          const SizedBox(height: 12),

          // 3 Contestants rows
          for (int i = 0; i < 3; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const NeoSkeletonBone(width: 22, height: 18, borderRadius: BorderRadius.all(Radius.circular(3))),
                  const SizedBox(width: 8),
                  const NeoSkeletonBone.circle(size: 24),
                  const SizedBox(width: 8),
                  const Expanded(child: NeoSkeletonBone.line(height: 13)),
                  const SizedBox(width: 8),
                  NeoSkeletonBone(
                    width: 32,
                    height: 22,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: NeoColors.border, width: 1),
                  ),
                ],
              ),
            ),
            if (i < 2) const Divider(color: NeoColors.neutralMuted, height: 8),
          ],
        ],
      ),
    );
  }
}
