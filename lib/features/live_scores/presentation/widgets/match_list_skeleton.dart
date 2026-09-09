import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/neo_skeleton.dart';

/// Skeleton placeholder for the Live Scores match list.
/// Matches the dimensions and Neo-Brutalist folder card styling of NsmqMatchCard.
class MatchListSkeleton extends StatelessWidget {
  final int itemCount;

  const MatchListSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return NeoSkeletonShimmer(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) => _buildSkeletonMatchCard(),
      ),
    );
  }

  Widget _buildSkeletonMatchCard() {
    return NeoSkeletonFolderCard(
      tabWidth: 150,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < 3; i++) ...[
            _buildSchoolRowSkeleton(),
            if (i < 2)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: NeoColors.neutralMuted, thickness: 1.5),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSchoolRowSkeleton() {
    return Row(
      children: [
        // 28px School Crest Avatar placeholder
        const NeoSkeletonBone.circle(size: 28),
        const SizedBox(width: 8),

        // School Name & Region lines
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              NeoSkeletonBone.line(height: 14),
              SizedBox(height: 4),
              NeoSkeletonBone.line(width: 60, height: 10),
            ],
          ),
        ),

        const SizedBox(width: 6),

        // 5 Round mini-score boxes
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int r = 0; r < 5; r++) ...[
              NeoSkeletonBone(
                width: 20,
                height: 22,
                borderRadius: BorderRadius.circular(4),
              ),
              if (r < 4) const SizedBox(width: 2),
            ],
          ],
        ),

        const SizedBox(width: 8),

        // Total Score Block placeholder
        NeoSkeletonBone(
          width: 38,
          height: 28,
          borderRadius: NeoBorders.radiusSm,
          border: Border.all(color: NeoColors.border, width: NeoBorders.strokeThin),
        ),
      ],
    );
  }
}
