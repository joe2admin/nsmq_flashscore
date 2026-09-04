import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsmq_flashscore/app/theme/app_borders.dart';
import 'package:nsmq_flashscore/app/theme/app_colors.dart';
import 'package:nsmq_flashscore/app/theme/app_shadows.dart';
import 'package:nsmq_flashscore/app/theme/app_typography.dart';
import 'package:nsmq_flashscore/core/widgets/neo_app_bar.dart';
import 'package:nsmq_flashscore/core/widgets/neo_empty_state.dart';
import 'package:nsmq_flashscore/features/news/domain/entities/news_article.dart';
import 'package:nsmq_flashscore/features/news/presentation/controllers/news_controller.dart';
import 'package:nsmq_flashscore/features/news/presentation/widgets/comments_sheet.dart';
import 'package:nsmq_flashscore/features/news/presentation/widgets/compose_post_sheet.dart';
import 'package:nsmq_flashscore/features/news/presentation/widgets/feed_post_card.dart';
import 'package:nsmq_flashscore/features/news/presentation/widgets/news_card.dart';

class NewsFeedView extends GetView<NewsController> {
  const NewsFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: const NeoAppBar(
        title: 'NSMQ FEED',
        subtitle: 'LIVE DISPATCHES & FAN BUZZ',
      ),
      floatingActionButton: _buildPostFloatingButton(context),
      body: Column(
        children: [
          // Twitter-style Category Selector Pills
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.categories.map((cat) {
                  return Obx(() {
                    final isSelected = controller.selectedCategory.value == cat;
                    return GestureDetector(
                      onTap: () => controller.selectCategory(cat),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? NeoColors.nsmqRed : NeoColors.surface,
                          borderRadius: NeoBorders.radiusSm,
                          border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                          boxShadow: isSelected ? NeoShadows.pill : NeoShadows.pill,
                        ),
                        child: Text(
                          cat,
                          style: NeoTypography.badge(
                            color: isSelected ? NeoColors.textLight : NeoColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
            ),
          ),

          // Main Twitter-style Feed Stream
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: NeoColors.nsmqRed),
                );
              }

              if (controller.selectedCategory.value == 'ARTICLES') {
                if (controller.articles.isEmpty) {
                  return const Center(
                    child: NeoEmptyState(
                      title: 'NO ARTICLES FOUND',
                      message: 'Check back later for published news reports.',
                      icon: Icons.article_outlined,
                    ),
                  );
                }
                return RefreshIndicator(
                  color: NeoColors.nsmqRed,
                  backgroundColor: NeoColors.surface,
                  onRefresh: controller.fetchPosts,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      final article = controller.articles[index];
                      return NewsCard(
                        article: article,
                        onTap: () => _showArticleDialog(context, article),
                      );
                    },
                  ),
                );
              }

              if (controller.feedPosts.isEmpty) {
                return const Center(
                  child: NeoEmptyState(
                    title: 'NO DISPATCHES FOUND',
                    message: 'No feed posts found in this topic. Check back or post a reaction!',
                    icon: Icons.dynamic_feed,
                  ),
                );
              }

              return RefreshIndicator(
                color: NeoColors.nsmqRed,
                backgroundColor: NeoColors.surface,
                onRefresh: controller.fetchPosts,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: controller.feedPosts.length,
                  itemBuilder: (context, index) {
                    final post = controller.feedPosts[index];
                    return FeedPostCard(
                      key: ValueKey(post.id),
                      post: post,
                      onLikeTap: () => controller.toggleLike(post.id),
                      onRetweetTap: () => controller.toggleRetweet(post.id),
                      onShareTap: () => controller.sharePost(post),
                      onBookmarkTap: () => controller.toggleBookmark(post.id),
                      onVotePoll: (optIdx) => controller.votePoll(post.id, optIdx),
                      onCommentTap: () {
                        CommentsSheet.show(
                          context,
                          post: post,
                          onAddComment: (commentText, {replyingToHandle}) {
                            controller.addComment(
                              post.id,
                              commentText,
                              replyingToHandle: replyingToHandle,
                            );
                          },
                          onToggleLikeComment: (commentId) {
                            controller.toggleCommentLike(post.id, commentId);
                          },
                        );
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

  Widget _buildPostFloatingButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NeoColors.nsmqRed,
        borderRadius: NeoBorders.radiusSm,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: NeoBorders.radiusSm,
          onTap: () {
            ComposePostSheet.show(
              context,
              onPublish: ({
                required String content,
                String? imageUrl,
                String? imageCaption,
                String category = 'LIVE BUZZ',
                String authorName = 'NSMQ Fan',
                String authorHandle = '@fan_gh',
                String? authorRole,
                required Color authorColor,
                String? crestUrl,
              }) {
                controller.addNewPost(
                  content: content,
                  imageUrl: imageUrl,
                  imageCaption: imageCaption,
                  category: category,
                  authorName: authorName,
                  authorHandle: authorHandle,
                  authorRole: authorRole,
                  authorColor: authorColor,
                  crestUrl: crestUrl,
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: NeoColors.textLight, size: 18),
                const SizedBox(width: 4),
                Text(
                  'POST',
                  style: NeoTypography.badge(color: NeoColors.textLight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showArticleDialog(BuildContext context, NewsArticle article) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: NeoColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: NeoBorders.radiusMd,
            side: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
          ),
          title: Text(
            article.title,
            style: NeoTypography.headingMedium(),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: NeoColors.surfaceYellow,
                        borderRadius: NeoBorders.radiusSm,
                        border: Border.all(color: NeoColors.border, width: 1),
                      ),
                      child: Text(
                        article.category,
                        style: NeoTypography.caption(color: NeoColors.textPrimary)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${article.timeAgo} • ${article.readTime}',
                      style: NeoTypography.caption(color: NeoColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  article.summary,
                  style: NeoTypography.bodyMedium(),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: NeoColors.surfaceMuted,
                    borderRadius: NeoBorders.radiusSm,
                    border: Border.all(color: NeoColors.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, color: NeoColors.nsmqBlue, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Official Primetime NSMQ Dispatch • nsmq.com.gh',
                          style: NeoTypography.caption(color: NeoColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'CLOSE',
                style: NeoTypography.badge(color: NeoColors.nsmqRed),
              ),
            ),
          ],
        );
      },
    );
  }
}
