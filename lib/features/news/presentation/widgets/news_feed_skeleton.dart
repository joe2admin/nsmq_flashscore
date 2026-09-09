import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../core/widgets/neo_skeleton.dart';

/// Skeleton placeholder for the News & Feed stream.
/// Can render both social feed post skeletons and news article skeletons.
class NewsFeedSkeleton extends StatelessWidget {
  final bool isArticles;
  final int itemCount;

  const NewsFeedSkeleton({
    super.key,
    this.isArticles = false,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return NeoSkeletonShimmer(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return isArticles
              ? _buildArticleCardSkeleton()
              : _buildPostCardSkeleton(hasImage: index % 2 == 0);
        },
      ),
    );
  }

  Widget _buildArticleCardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NeoSkeletonBone.badge(width: 80, height: 22),
              NeoSkeletonBone.line(width: 90, height: 12),
            ],
          ),
          SizedBox(height: 12),
          NeoSkeletonBone.line(height: 16),
          SizedBox(height: 6),
          NeoSkeletonBone.line(width: 200, height: 16),
          SizedBox(height: 10),
          NeoSkeletonBone.line(height: 12),
          SizedBox(height: 4),
          NeoSkeletonBone.line(width: 240, height: 12),
        ],
      ),
    );
  }

  Widget _buildPostCardSkeleton({required bool hasImage}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Handle
          const Row(
            children: [
              NeoSkeletonBone.circle(size: 40),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        NeoSkeletonBone.line(width: 110, height: 14),
                        SizedBox(width: 6),
                        NeoSkeletonBone.circle(size: 14),
                      ],
                    ),
                    SizedBox(height: 4),
                    NeoSkeletonBone.line(width: 70, height: 11),
                  ],
                ),
              ),
              NeoSkeletonBone.line(width: 40, height: 11),
            ],
          ),

          const SizedBox(height: 12),

          // Content lines
          const NeoSkeletonBone.line(height: 13),
          const SizedBox(height: 6),
          const NeoSkeletonBone.line(height: 13),
          const SizedBox(height: 6),
          const NeoSkeletonBone.line(width: 180, height: 13),

          // Image media placeholder
          if (hasImage) ...[
            const SizedBox(height: 12),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: NeoColors.background,
                borderRadius: NeoBorders.radiusMd,
                border: Border.all(color: NeoColors.border, width: 1.5),
              ),
              child: const Center(
                child: Icon(Icons.image_outlined, size: 36, color: NeoColors.neutralMuted),
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Action bar
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NeoSkeletonBone(width: 50, height: 20, borderRadius: BorderRadius.all(Radius.circular(10))),
              NeoSkeletonBone(width: 50, height: 20, borderRadius: BorderRadius.all(Radius.circular(10))),
              NeoSkeletonBone(width: 50, height: 20, borderRadius: BorderRadius.all(Radius.circular(10))),
              NeoSkeletonBone(width: 30, height: 20, borderRadius: BorderRadius.all(Radius.circular(10))),
            ],
          ),
        ],
      ),
    );
  }
}
