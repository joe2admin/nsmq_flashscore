import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../core/widgets/neo_skeleton.dart';

/// Skeleton placeholder for the Schools Directory list view.
/// Mimics the SchoolTileCard layout and Neo-Brutalist card styling.
class SchoolsDirectorySkeleton extends StatelessWidget {
  final int itemCount;

  const SchoolsDirectorySkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return NeoSkeletonShimmer(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) => _buildSchoolTileSkeleton(),
      ),
    );
  }

  Widget _buildSchoolTileSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: const Row(
        children: [
          // School Crest 46x46 Avatar placeholder
          NeoSkeletonBone.circle(size: 46),
          SizedBox(width: 12),

          // School Name & Region info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeoSkeletonBone.line(height: 15),
                SizedBox(height: 6),
                Row(
                  children: [
                    NeoSkeletonBone.badge(width: 70, height: 18),
                    SizedBox(width: 6),
                    NeoSkeletonBone.badge(width: 50, height: 18),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 8),

          // Favorite star placeholder
          NeoSkeletonBone.circle(size: 24),
        ],
      ),
    );
  }
}
