import 'package:nsmq_flashscore/features/news/domain/entities/feed_post.dart';
import 'package:nsmq_flashscore/features/news/domain/entities/news_article.dart';

abstract class INewsRepository {
  /// Fetches Twitter-style micro-blogging feed posts, optionally filtered by category
  Future<List<FeedPost>> getFeedPosts({String? category});

  /// Toggles like state for a post
  Future<bool> toggleLike(String postId);

  /// Toggles retweet / repost state for a post
  Future<bool> toggleRetweet(String postId);

  /// Toggles bookmark state for a post
  Future<bool> toggleBookmark(String postId);

  /// Adds a reply comment to a post
  Future<FeedComment> addComment(
    String postId,
    String commentText, {
    String authorName = 'NSMQ Fan',
    String authorHandle = '@fan_gh',
    String? replyingToHandle,
  });

  /// Toggles like state for an individual comment
  Future<bool> toggleCommentLike(String postId, String commentId);

  /// Submits a vote on a poll/quiz attached to a post
  Future<FeedPost> votePoll(String postId, int optionIndex);

  /// Publishes a new dispatch/post to the feed
  Future<FeedPost> createPost(FeedPost post);

  /// Legacy articles fetcher (for backward compatibility)
  Future<List<NewsArticle>> getArticles({String? category});
}
