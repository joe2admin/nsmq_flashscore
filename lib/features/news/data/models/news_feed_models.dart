import 'package:flutter/material.dart';
import '../../domain/entities/feed_post.dart';
import '../../domain/entities/news_article.dart';

Color _parseColor(dynamic colorVal, [Color defaultColor = const Color(0xFFE51B24)]) {
  if (colorVal is Color) return colorVal;
  if (colorVal is String && colorVal.isNotEmpty) {
    try {
      final hex = colorVal.replaceAll('#', '').trim();
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
  }
  return defaultColor;
}

class FeedPollOptionModel extends FeedPollOption {
  const FeedPollOptionModel({
    required super.id,
    required super.text,
    super.votes = 0,
    super.isCorrect = false,
  });

  factory FeedPollOptionModel.fromJson(Map<String, dynamic> json) {
    return FeedPollOptionModel(
      id: json['id']?.toString() ?? '',
      text: json['text'] as String? ?? '',
      votes: int.tryParse((json['votes'] ?? 0).toString()) ?? 0,
      isCorrect: (json['is_correct'] ?? json['isCorrect']) as bool? ?? false,
    );
  }
}

class FeedPollModel extends FeedPoll {
  const FeedPollModel({
    required super.question,
    required super.options,
    super.totalVotes = 0,
    super.userVotedIndex,
    super.isQuiz = false,
    super.explanation,
  });

  factory FeedPollModel.fromJson(Map<String, dynamic> json) {
    final optsRaw = json['options'] as List<dynamic>? ?? [];
    final options = optsRaw
        .map((e) => FeedPollOptionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return FeedPollModel(
      question: json['question'] as String? ?? '',
      options: options,
      totalVotes: int.tryParse((json['total_votes'] ?? json['totalVotes'] ?? 0).toString()) ?? 0,
      userVotedIndex: json['user_voted_index'] != null
          ? int.tryParse(json['user_voted_index'].toString())
          : (json['userVotedIndex'] != null ? int.tryParse(json['userVotedIndex'].toString()) : null),
      isQuiz: (json['is_quiz'] ?? json['isQuiz']) as bool? ?? false,
      explanation: json['explanation'] as String?,
    );
  }
}

class FeedCommentModel extends FeedComment {
  const FeedCommentModel({
    required super.id,
    required super.authorName,
    required super.authorHandle,
    required super.authorInitials,
    required super.authorColor,
    required super.content,
    required super.timeAgo,
    super.likesCount = 0,
    super.isLiked = false,
    super.replyingToHandle,
  });

  factory FeedCommentModel.fromJson(Map<String, dynamic> json) {
    return FeedCommentModel(
      id: json['id']?.toString() ?? '',
      authorName: (json['author_name'] ?? json['authorName']) as String? ?? 'Fan',
      authorHandle: (json['author_handle'] ?? json['authorHandle']) as String? ?? '@fan',
      authorInitials: (json['author_initials'] ?? json['authorInitials']) as String? ?? 'F',
      authorColor: _parseColor(json['author_color'] ?? json['authorColor']),
      content: json['content'] as String? ?? '',
      timeAgo: (json['time_ago'] ?? json['timeAgo']) as String? ?? 'Just now',
      likesCount: int.tryParse((json['likes_count'] ?? json['likesCount'] ?? 0).toString()) ?? 0,
      isLiked: (json['is_liked'] ?? json['isLiked']) as bool? ?? false,
      replyingToHandle: (json['replying_to_handle'] ?? json['replyingToHandle']) as String?,
    );
  }
}

class FeedPostModel extends FeedPost {
  const FeedPostModel({
    required super.id,
    required super.authorName,
    required super.authorHandle,
    required super.authorInitials,
    required super.authorColor,
    super.isVerified = false,
    super.authorRole,
    required super.content,
    required super.timeAgo,
    super.imageUrl,
    super.imageCaption,
    super.imageAspectRatio,
    super.likesCount = 0,
    super.isLiked = false,
    super.commentsCount = 0,
    super.sharesCount = 0,
    super.isRetweeted = false,
    super.isBookmarked = false,
    super.category = 'FOR YOU',
    super.comments = const [],
    super.poll,
    super.schoolId,
    super.crestUrl,
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    final commentsRaw = json['comments'] as List<dynamic>? ?? [];
    final comments = commentsRaw
        .map((e) => FeedCommentModel.fromJson(e as Map<String, dynamic>))
        .toList();

    FeedPoll? poll;
    if (json['poll'] != null && json['poll'] is Map<String, dynamic>) {
      poll = FeedPollModel.fromJson(json['poll'] as Map<String, dynamic>);
    }

    final double? aspectRatio = json['image_aspect_ratio'] != null
        ? double.tryParse(json['image_aspect_ratio'].toString())
        : (json['imageAspectRatio'] != null ? double.tryParse(json['imageAspectRatio'].toString()) : null);

    return FeedPostModel(
      id: json['id']?.toString() ?? '',
      authorName: (json['author_name'] ?? json['authorName']) as String? ?? 'NSMQ Ghana',
      authorHandle: (json['author_handle'] ?? json['authorHandle']) as String? ?? '@NSMQGhana',
      authorInitials: (json['author_initials'] ?? json['authorInitials']) as String? ?? 'NS',
      authorColor: _parseColor(json['author_color'] ?? json['authorColor']),
      isVerified: (json['is_verified'] ?? json['isVerified']) as bool? ?? false,
      authorRole: (json['author_role'] ?? json['authorRole']) as String?,
      content: json['content'] as String? ?? '',
      timeAgo: (json['time_ago'] ?? json['timeAgo']) as String? ?? 'Recently',
      imageUrl: (json['image_url'] ?? json['imageUrl']) as String?,
      imageCaption: (json['image_caption'] ?? json['imageCaption']) as String?,
      imageAspectRatio: aspectRatio,
      likesCount: int.tryParse((json['likes_count'] ?? json['likesCount'] ?? 0).toString()) ?? 0,
      isLiked: (json['is_liked'] ?? json['isLiked']) as bool? ?? false,
      commentsCount: int.tryParse((json['comments_count'] ?? json['commentsCount'] ?? 0).toString()) ?? 0,
      sharesCount: int.tryParse((json['shares_count'] ?? json['sharesCount'] ?? 0).toString()) ?? 0,
      isRetweeted: (json['is_retweeted'] ?? json['isRetweeted']) as bool? ?? false,
      isBookmarked: (json['is_bookmarked'] ?? json['isBookmarked']) as bool? ?? false,
      category: json['category'] as String? ?? 'FOR YOU',
      comments: comments,
      poll: poll,
      schoolId: (json['school_id'] ?? json['schoolId']) as String?,
      crestUrl: (json['crest_url'] ?? json['crestUrl']) as String?,
    );
  }
}

class NewsArticleModel extends NewsArticle {
  const NewsArticleModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.timeAgo,
    required super.category,
    super.readTime = '3 min read',
    super.isFeatured = false,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      timeAgo: (json['time_ago'] ?? json['timeAgo']) as String? ?? 'Recently',
      category: json['category'] as String? ?? 'NEWS',
      readTime: (json['read_time'] ?? json['readTime']) as String? ?? '3 min read',
      isFeatured: (json['is_featured'] ?? json['isFeatured']) as bool? ?? false,
    );
  }
}
