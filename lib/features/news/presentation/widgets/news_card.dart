import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import 'package:nsmq_flashscore/features/news/domain/entities/news_article.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback? onTap;

  const NewsCard({super.key, required this.article, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: article.isFeatured ? NeoColors.surfaceYellow : NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: NeoBorders.radiusMd,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: article.isFeatured ? NeoColors.nsmqRed : NeoColors.surfaceBlue,
                        borderRadius: NeoBorders.radiusSm,
                        border: Border.all(color: NeoColors.border, width: 1),
                      ),
                      child: Text(
                        article.category,
                        style: NeoTypography.badge(
                          color: article.isFeatured ? NeoColors.textLight : NeoColors.nsmqBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${article.timeAgo} • ${article.readTime}',
                        style: NeoTypography.caption(color: NeoColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Title
                Text(
                  article.title,
                  style: NeoTypography.headingMedium(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Summary
                Text(
                  article.summary,
                  style: NeoTypography.bodyRegular(color: NeoColors.textSecondary),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'READ ANALYSIS →',
                      style: NeoTypography.badge(color: NeoColors.nsmqRed),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
