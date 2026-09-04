import 'package:flutter/material.dart';

/// Represents an option within a Twitter-style feed poll or quiz
class FeedPollOption {
  final String id;
  final String text;
  final int votes;
  final bool isCorrect; // optional for quiz-style riddles

  const FeedPollOption({
    required this.id,
    required this.text,
    this.votes = 0,
    this.isCorrect = false,
  });

  FeedPollOption copyWith({
    String? id,
    String? text,
    int? votes,
    bool? isCorrect,
  }) {
    return FeedPollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      votes: votes ?? this.votes,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}

/// Represents an interactive poll or quiz attached to a feed post
class FeedPoll {
  final String question;
  final List<FeedPollOption> options;
  final int totalVotes;
  final int? userVotedIndex;
  final bool isQuiz;
  final String? explanation;

  const FeedPoll({
    required this.question,
    required this.options,
    this.totalVotes = 0,
    this.userVotedIndex,
    this.isQuiz = false,
    this.explanation,
  });

  FeedPoll copyWith({
    String? question,
    List<FeedPollOption>? options,
    int? totalVotes,
    int? userVotedIndex,
    bool? isQuiz,
    String? explanation,
  }) {
    return FeedPoll(
      question: question ?? this.question,
      options: options ?? this.options,
      totalVotes: totalVotes ?? this.totalVotes,
      userVotedIndex: userVotedIndex ?? this.userVotedIndex,
      isQuiz: isQuiz ?? this.isQuiz,
      explanation: explanation ?? this.explanation,
    );
  }
}

/// Represents a comment or reply on a feed post
class FeedComment {
  final String id;
  final String authorName;
  final String authorHandle;
  final String authorInitials;
  final Color authorColor;
  final String content;
  final String timeAgo;
  final int likesCount;
  final bool isLiked;
  final String? replyingToHandle;

  const FeedComment({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    required this.authorInitials,
    required this.authorColor,
    required this.content,
    required this.timeAgo,
    this.likesCount = 0,
    this.isLiked = false,
    this.replyingToHandle,
  });

  FeedComment copyWith({
    String? id,
    String? authorName,
    String? authorHandle,
    String? authorInitials,
    Color? authorColor,
    String? content,
    String? timeAgo,
    int? likesCount,
    bool? isLiked,
    String? replyingToHandle,
  }) {
    return FeedComment(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorHandle: authorHandle ?? this.authorHandle,
      authorInitials: authorInitials ?? this.authorInitials,
      authorColor: authorColor ?? this.authorColor,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      replyingToHandle: replyingToHandle ?? this.replyingToHandle,
    );
  }
}

/// A micro-blogging feed dispatch/tweet in the NSMQ feed
class FeedPost {
  final String id;
  final String authorName;
  final String authorHandle;
  final String authorInitials;
  final Color authorColor;
  final bool isVerified;
  final String? authorRole; // e.g. "OFFICIAL", "8x CHAMPIONS", "QUIZ MISTRESS"
  final String content;
  final String timeAgo;
  final String? imageUrl;
  final String? imageCaption;
  final double? imageAspectRatio;
  final int likesCount;
  final bool isLiked;
  final int commentsCount;
  final int sharesCount;
  final bool isRetweeted;
  final bool isBookmarked;
  final String category; // "LIVE BUZZ", "OFFICIAL", "PHOTOS", "POLLS"
  final List<FeedComment> comments;
  final FeedPoll? poll;
  final String? schoolId;
  final String? crestUrl;

  const FeedPost({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    required this.authorInitials,
    required this.authorColor,
    this.isVerified = false,
    this.authorRole,
    required this.content,
    required this.timeAgo,
    this.imageUrl,
    this.imageCaption,
    this.imageAspectRatio,
    this.likesCount = 0,
    this.isLiked = false,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isRetweeted = false,
    this.isBookmarked = false,
    this.category = 'FOR YOU',
    this.comments = const [],
    this.poll,
    this.schoolId,
    this.crestUrl,
  });

  FeedPost copyWith({
    String? id,
    String? authorName,
    String? authorHandle,
    String? authorInitials,
    Color? authorColor,
    bool? isVerified,
    String? authorRole,
    String? content,
    String? timeAgo,
    String? imageUrl,
    String? imageCaption,
    double? imageAspectRatio,
    int? likesCount,
    bool? isLiked,
    int? commentsCount,
    int? sharesCount,
    bool? isRetweeted,
    bool? isBookmarked,
    String? category,
    List<FeedComment>? comments,
    FeedPoll? poll,
    String? schoolId,
    String? crestUrl,
  }) {
    return FeedPost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorHandle: authorHandle ?? this.authorHandle,
      authorInitials: authorInitials ?? this.authorInitials,
      authorColor: authorColor ?? this.authorColor,
      isVerified: isVerified ?? this.isVerified,
      authorRole: authorRole ?? this.authorRole,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
      imageUrl: imageUrl ?? this.imageUrl,
      imageCaption: imageCaption ?? this.imageCaption,
      imageAspectRatio: imageAspectRatio ?? this.imageAspectRatio,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isRetweeted: isRetweeted ?? this.isRetweeted,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      category: category ?? this.category,
      comments: comments ?? this.comments,
      poll: poll ?? this.poll,
      schoolId: schoolId ?? this.schoolId,
      crestUrl: crestUrl ?? this.crestUrl,
    );
  }
}
