import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsmq_flashscore/app/theme/app_borders.dart';
import 'package:nsmq_flashscore/app/theme/app_colors.dart';
import 'package:nsmq_flashscore/app/theme/app_typography.dart';
import 'package:nsmq_flashscore/features/news/domain/entities/feed_post.dart';
import 'package:nsmq_flashscore/features/news/domain/entities/news_article.dart';
import 'package:nsmq_flashscore/features/news/domain/repositories/i_news_repository.dart';

class NewsController extends GetxController {
  final INewsRepository repository;

  NewsController({required this.repository});

  final RxList<FeedPost> feedPosts = <FeedPost>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = 'FOR YOU'.obs;

  final List<String> categories = const [
    'FOR YOU',
    'ARTICLES',
    'LIVE BUZZ',
    'OFFICIAL',
    'PHOTOS',
    'POLLS',
  ];

  // Backward compatibility legacy fields
  final RxList<NewsArticle> articles = <NewsArticle>[].obs;
  final RxInt selectedQuizOption = (-1).obs;
  final RxBool quizSubmitted = false.obs;
  final int correctOptionIndex = 1;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    try {
      if (selectedCategory.value == 'ARTICLES') {
        final articleList = await repository.getArticles();
        articles.assignAll(articleList);
      } else {
        final list = await repository.getFeedPosts(category: selectedCategory.value);
        feedPosts.assignAll(list);
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    fetchPosts();
  }

  Future<void> toggleLike(String postId) async {
    final index = feedPosts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = feedPosts[index];
    final newLiked = !post.isLiked;
    final newLikesCount = newLiked ? post.likesCount + 1 : (post.likesCount > 0 ? post.likesCount - 1 : 0);

    feedPosts[index] = post.copyWith(
      isLiked: newLiked,
      likesCount: newLikesCount,
    );

    try {
      await repository.toggleLike(postId);
    } catch (e) {
      // Revert if error
      feedPosts[index] = post;
    }
  }

  Future<void> toggleRetweet(String postId) async {
    final index = feedPosts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = feedPosts[index];
    final newRetweeted = !post.isRetweeted;
    final newSharesCount = newRetweeted ? post.sharesCount + 1 : (post.sharesCount > 0 ? post.sharesCount - 1 : 0);

    feedPosts[index] = post.copyWith(
      isRetweeted: newRetweeted,
      sharesCount: newSharesCount,
    );

    if (newRetweeted) {
      showNeoSnackbar(
        title: 'REPOSTED',
        message: 'Dispatch reposted to your NSMQ feed!',
        icon: Icons.repeat,
        iconColor: NeoColors.green,
      );
    }

    try {
      await repository.toggleRetweet(postId);
    } catch (e) {
      feedPosts[index] = post;
    }
  }

  Future<void> toggleBookmark(String postId) async {
    final index = feedPosts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = feedPosts[index];
    final newBookmarked = !post.isBookmarked;

    feedPosts[index] = post.copyWith(isBookmarked: newBookmarked);

    showNeoSnackbar(
      title: newBookmarked ? 'SAVED' : 'REMOVED',
      message: newBookmarked ? 'Post added to your bookmarks.' : 'Post removed from bookmarks.',
      icon: newBookmarked ? Icons.bookmark : Icons.bookmark_border,
      iconColor: NeoColors.gold,
    );

    try {
      await repository.toggleBookmark(postId);
    } catch (e) {
      feedPosts[index] = post;
    }
  }

  void sharePost(FeedPost post) {
    showNeoSnackbar(
      title: 'LINK COPIED',
      message: 'Post link copied to clipboard! Share the NSMQ buzz 📋',
      icon: Icons.share,
      iconColor: NeoColors.nsmqBlue,
    );
  }

  Future<void> addComment(
    String postId,
    String commentText, {
    String authorName = 'NSMQ Fan',
    String authorHandle = '@fan_gh',
    String? replyingToHandle,
  }) async {
    if (commentText.trim().isEmpty) return;

    final index = feedPosts.indexWhere((p) => p.id == postId);
    try {
      final comment = await repository.addComment(
        postId,
        commentText.trim(),
        authorName: authorName,
        authorHandle: authorHandle,
        replyingToHandle: replyingToHandle,
      );

      if (index != -1) {
        final post = feedPosts[index];
        feedPosts[index] = post.copyWith(
          comments: [comment, ...post.comments],
          commentsCount: post.commentsCount + 1,
        );
      }
    } catch (e) {
      debugPrint('Error adding comment: $e');
    }
  }

  Future<void> toggleCommentLike(String postId, String commentId) async {
    final postIndex = feedPosts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    final post = feedPosts[postIndex];
    final commentIndex = post.comments.indexWhere((c) => c.id == commentId);
    if (commentIndex == -1) return;

    final comment = post.comments[commentIndex];
    final newLiked = !comment.isLiked;
    final newCount = newLiked ? comment.likesCount + 1 : (comment.likesCount > 0 ? comment.likesCount - 1 : 0);

    final updatedComment = comment.copyWith(
      isLiked: newLiked,
      likesCount: newCount,
    );

    final updatedList = List<FeedComment>.from(post.comments);
    updatedList[commentIndex] = updatedComment;
    feedPosts[postIndex] = post.copyWith(comments: updatedList);

    try {
      await repository.toggleCommentLike(postId, commentId);
    } catch (e) {
      final revertList = List<FeedComment>.from(post.comments);
      revertList[commentIndex] = comment;
      feedPosts[postIndex] = post.copyWith(comments: revertList);
    }
  }

  Future<void> votePoll(String postId, int optionIndex) async {
    final index = feedPosts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    try {
      final updatedPost = await repository.votePoll(postId, optionIndex);
      feedPosts[index] = updatedPost;

      showNeoSnackbar(
        title: 'VOTE RECORDED',
        message: 'Your vote has been counted!',
        icon: Icons.how_to_vote,
        iconColor: NeoColors.nsmqElectricBlue,
      );
    } catch (e) {
      debugPrint('Error voting on poll: $e');
    }
  }

  Future<void> addNewPost({
    required String content,
    String? imageUrl,
    String? imageCaption,
    String category = 'LIVE BUZZ',
    String authorName = 'NSMQ Fan',
    String authorHandle = '@fan_gh',
    String? authorRole = 'FAN',
    Color authorColor = NeoColors.nsmqRed,
    String? crestUrl,
    String? schoolId,
  }) async {
    if (content.trim().isEmpty) return;

    final newPost = FeedPost(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorName: authorName,
      authorHandle: authorHandle,
      authorInitials: authorName.length >= 2 ? authorName.substring(0, 2).toUpperCase() : 'NS',
      authorColor: authorColor,
      isVerified: false,
      authorRole: authorRole,
      content: content.trim(),
      timeAgo: 'Just now',
      imageUrl: imageUrl,
      imageCaption: imageCaption,
      imageAspectRatio: imageUrl != null ? 16 / 9 : null,
      likesCount: 0,
      commentsCount: 0,
      sharesCount: 0,
      category: category,
      comments: const [],
      crestUrl: crestUrl,
      schoolId: schoolId,
    );

    await repository.createPost(newPost);
    feedPosts.insert(0, newPost);

    showNeoSnackbar(
      title: 'DISPATCH PUBLISHED',
      message: 'Your post is now live on the NSMQ feed!',
      icon: Icons.send,
      iconColor: NeoColors.nsmqRed,
    );
  }

  void showNeoSnackbar({
    required String title,
    required String message,
    required IconData icon,
    Color iconColor = NeoColors.nsmqRed,
  }) {
    if (Get.context == null) return;
    Get.rawSnackbar(
      titleText: Text(
        title,
        style: NeoTypography.badge(color: NeoColors.textLight),
      ),
      messageText: Text(
        message,
        style: NeoTypography.bodyRegular(color: NeoColors.textLight, size: 12),
      ),
      backgroundColor: NeoColors.darkCanvas,
      borderRadius: NeoBorders.sm,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      icon: Icon(icon, color: iconColor, size: 22),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
      borderColor: NeoColors.border,
      borderWidth: 2,
    );
  }

  // Legacy Quiz methods
  Future<void> fetchArticles() async {
    await fetchPosts();
  }

  void answerQuiz(int index) {
    if (quizSubmitted.value) return;
    selectedQuizOption.value = index;
    quizSubmitted.value = true;
  }

  void resetQuiz() {
    selectedQuizOption.value = -1;
    quizSubmitted.value = false;
  }
}
