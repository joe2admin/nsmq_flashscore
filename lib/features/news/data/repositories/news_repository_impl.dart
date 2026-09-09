import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import 'package:nsmq_flashscore/app/theme/app_colors.dart';
import 'package:nsmq_flashscore/core/constants/school_assets.dart';
import '../models/news_feed_models.dart';
import '../../domain/entities/feed_post.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/i_news_repository.dart';

class NewsRepositoryImpl implements INewsRepository {
  final ApiClient _apiClient;
  List<FeedPost> _posts = [];

  NewsRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? (Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : ApiClient()) {
    _initMockPosts();
  }

  @override
  Future<List<FeedPost>> getFeedPosts({String? category}) async {
    try {
      final query = <String, dynamic>{};
      if (category != null && category != 'FOR YOU' && category != 'ALL') {
        query['category'] = category;
      }

      final response = await _apiClient.safeGet(ApiEndpoints.feed, query: query);
      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;
        if (dataRaw is List) {
          final livePosts = dataRaw
              .map((e) => FeedPostModel.fromJson(e as Map<String, dynamic>))
              .toList();
          _posts = livePosts;
          return List.unmodifiable(_posts);
        }
      }
    } catch (e) {
      debugPrint('[NewsRepositoryImpl] getFeedPosts backend error, falling back to mock: $e');
    }

    // Fallback to local mock posts
    if (category == null || category == 'FOR YOU' || category == 'ALL') {
      return List.unmodifiable(_posts);
    }
    if (category == 'PHOTOS') {
      return _posts.where((p) => p.imageUrl != null).toList();
    }
    if (category == 'POLLS') {
      return _posts.where((p) => p.poll != null).toList();
    }
    return _posts.where((p) => p.category.toUpperCase() == category.toUpperCase()).toList();
  }

  @override
  Future<bool> toggleLike(String postId) async {
    // 1. Optimistic update
    final index = _posts.indexWhere((p) => p.id == postId);
    bool newLiked = true;
    if (index != -1) {
      final post = _posts[index];
      newLiked = !post.isLiked;
      final newLikesCount = newLiked ? post.likesCount + 1 : (post.likesCount > 0 ? post.likesCount - 1 : 0);
      _posts[index] = post.copyWith(
        isLiked: newLiked,
        likesCount: newLikesCount,
      );
    }

    // 2. Persist to backend
    try {
      final response = await _apiClient.safePost(ApiEndpoints.feedLike(postId), {});
      if (response.isOk && response.body != null && index != -1) {
        final body = response.body;
        final dynamic isLikedVal = body is Map ? (body['is_liked'] ?? body['isLiked']) : null;
        final dynamic likesCountVal = body is Map ? (body['likes_count'] ?? body['likesCount']) : null;
        if (isLikedVal is bool) {
          _posts[index] = _posts[index].copyWith(
            isLiked: isLikedVal,
            likesCount: int.tryParse(likesCountVal?.toString() ?? '') ?? _posts[index].likesCount,
          );
          return isLikedVal;
        }
      }
    } catch (e) {
      debugPrint('[NewsRepositoryImpl] toggleLike backend error: $e');
    }

    return newLiked;
  }

  @override
  Future<bool> toggleRetweet(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    bool newRetweeted = true;
    if (index != -1) {
      final post = _posts[index];
      newRetweeted = !post.isRetweeted;
      final newSharesCount = newRetweeted ? post.sharesCount + 1 : (post.sharesCount > 0 ? post.sharesCount - 1 : 0);
      _posts[index] = post.copyWith(
        isRetweeted: newRetweeted,
        sharesCount: newSharesCount,
      );
    }

    try {
      final response = await _apiClient.safePost(ApiEndpoints.feedRetweet(postId), {});
      if (response.isOk && response.body != null && index != -1) {
        final body = response.body;
        final dynamic isRetweetedVal = body is Map ? (body['is_retweeted'] ?? body['isRetweeted']) : null;
        if (isRetweetedVal != null) {
          return isRetweetedVal as bool;
        }
      }
    } catch (e) {
      debugPrint('[NewsRepositoryImpl] toggleRetweet backend error: $e');
    }

    return newRetweeted;
  }

  @override
  Future<bool> toggleBookmark(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    bool newBookmarked = true;
    if (index != -1) {
      final post = _posts[index];
      newBookmarked = !post.isBookmarked;
      _posts[index] = post.copyWith(isBookmarked: newBookmarked);
    }

    try {
      final response = await _apiClient.safePost(ApiEndpoints.feedBookmark(postId), {});
      if (response.isOk && response.body != null && index != -1) {
        final body = response.body;
        final dynamic isBookmarkedVal = body is Map ? (body['is_bookmarked'] ?? body['isBookmarked']) : null;
        if (isBookmarkedVal != null) {
          return isBookmarkedVal as bool;
        }
      }
    } catch (e) {
      debugPrint('[NewsRepositoryImpl] toggleBookmark backend error: $e');
    }

    return newBookmarked;
  }

  @override
  Future<FeedComment> addComment(
    String postId,
    String commentText, {
    String authorName = 'NSMQ Fan',
    String authorHandle = '@fan_gh',
    String? replyingToHandle,
  }) async {
    try {
      final payload = {
        'content': commentText,
        'author_name': authorName,
        'author_handle': authorHandle,
        'replying_to_handle': ?replyingToHandle,
      };

      final response = await _apiClient.safePost(ApiEndpoints.feedComments(postId), payload);
      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;
        if (dataRaw is Map<String, dynamic>) {
          final liveComment = FeedCommentModel.fromJson(dataRaw);
          final index = _posts.indexWhere((p) => p.id == postId);
          if (index != -1) {
            final post = _posts[index];
            _posts[index] = post.copyWith(
              comments: [liveComment, ...post.comments],
              commentsCount: post.commentsCount + 1,
            );
          }
          return liveComment;
        }
      }
    } catch (e) {
      debugPrint('[NewsRepositoryImpl] addComment backend error: $e');
    }

    // Fallback comment creation
    final index = _posts.indexWhere((p) => p.id == postId);
    final comment = FeedComment(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      authorName: authorName,
      authorHandle: authorHandle,
      authorInitials: authorName.substring(0, 1).toUpperCase(),
      authorColor: NeoColors.nsmqRed,
      content: commentText,
      timeAgo: 'Just now',
      likesCount: 0,
      isLiked: false,
      replyingToHandle: replyingToHandle,
    );

    if (index != -1) {
      final post = _posts[index];
      final updatedComments = [comment, ...post.comments];
      _posts[index] = post.copyWith(
        comments: updatedComments,
        commentsCount: post.commentsCount + 1,
      );
    }
    return comment;
  }

  @override
  Future<bool> toggleCommentLike(String postId, String commentId) async {
    bool newLiked = true;
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final commentIndex = post.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final comment = post.comments[commentIndex];
        newLiked = !comment.isLiked;
        final newCount = newLiked ? comment.likesCount + 1 : (comment.likesCount > 0 ? comment.likesCount - 1 : 0);
        final updatedComment = comment.copyWith(isLiked: newLiked, likesCount: newCount);
        final updatedList = List<FeedComment>.from(post.comments);
        updatedList[commentIndex] = updatedComment;
        _posts[postIndex] = post.copyWith(comments: updatedList);
      }
    }

    try {
      final response = await _apiClient.safePost(ApiEndpoints.feedCommentLike(postId, commentId), {});
      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic isLikedVal = body is Map ? (body['is_liked'] ?? body['isLiked']) : null;
        if (isLikedVal != null) return isLikedVal as bool;
      }
    } catch (e) {
      debugPrint('[NewsRepositoryImpl] toggleCommentLike backend error: $e');
    }

    return newLiked;
  }

  @override
  Future<FeedPost> votePoll(String postId, int optionIndex) async {
    try {
      final response = await _apiClient.safePost(
        ApiEndpoints.feedVote(postId),
        {'option_index': optionIndex},
      );

      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;
        if (dataRaw is Map<String, dynamic>) {
          final updatedPost = FeedPostModel.fromJson(dataRaw);
          final index = _posts.indexWhere((p) => p.id == postId);
          if (index != -1) {
            _posts[index] = updatedPost;
          }
          return updatedPost;
        }
      }
    } catch (e) {
      debugPrint('[NewsRepositoryImpl] votePoll backend error: $e');
    }

    // Fallback local poll voting
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) throw Exception('Post not found');

    final post = _posts[index];
    if (post.poll == null) return post;

    final poll = post.poll!;
    if (poll.userVotedIndex != null) return post;

    final updatedOptions = poll.options.asMap().entries.map((entry) {
      final idx = entry.key;
      final opt = entry.value;
      if (idx == optionIndex) {
        return opt.copyWith(votes: opt.votes + 1);
      }
      return opt;
    }).toList();

    final updatedPoll = poll.copyWith(
      options: updatedOptions,
      totalVotes: poll.totalVotes + 1,
      userVotedIndex: optionIndex,
    );

    _posts[index] = post.copyWith(poll: updatedPoll);
    return _posts[index];
  }

  @override
  Future<FeedPost> createPost(FeedPost post) async {
    // 1. Optimistic prepend
    _posts.insert(0, post);

    // 2. Persist to backend
    try {
      final payload = {
        'content': post.content,
        'author_name': post.authorName,
        'author_handle': post.authorHandle,
        'author_role': post.authorRole,
        'category': post.category,
        'school_id': post.schoolId,
        'image_url': post.imageUrl,
        'image_caption': post.imageCaption,
      };

      final response = await _apiClient.safePost(ApiEndpoints.feed, payload);
      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;
        if (dataRaw is Map<String, dynamic>) {
          final livePost = FeedPostModel.fromJson(dataRaw);
          final idx = _posts.indexWhere((p) => p.id == post.id);
          if (idx != -1) {
            _posts[idx] = livePost;
          }
          return livePost;
        }
      }
    } catch (e) {
      debugPrint('[NewsRepositoryImpl] createPost backend error: $e');
    }

    return post;
  }

  @override
  Future<List<NewsArticle>> getArticles({String? category}) async {
    try {
      final query = <String, dynamic>{};
      if (category != null && category != 'ALL' && category != 'FOR YOU') {
        query['category'] = category;
      }

      final response = await _apiClient.safeGet(ApiEndpoints.news, query: query);
      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;
        if (dataRaw is List) {
          return dataRaw
              .map((e) => NewsArticleModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('[NewsRepositoryImpl] getArticles backend error, falling back to mock: $e');
    }

    const articles = [
      NewsArticle(
        id: 'art_1',
        title:
            'Accra Academy Beats Achimota School and Bright SHS to Secure First-Ever Grand Finale Spot, Sweep GH¢8,800 in Awards!',
        summary:
            'For Accra Academy, it was a chance to make history by securing their first-ever place at the Grand Finale of the 2026 National Championship. They scored a commanding 54 points at the UCC Main Auditorium after a dramatic 5-round battle.',
        timeAgo: '13 hours ago',
        category: 'NEWS',
        readTime: '4 min read',
        isFeatured: true,
      ),
      NewsArticle(
        id: 'art_2',
        title: 'PRESEC, Legon Stands Tall, Returns to the Grand Finale After Two Years!',
        summary:
            'Eight-time champions Presbyterian Boys\' Secondary School held their nerve through a fiercely contested encounter with St. John\'s School and Tamale SHS, pulling away in the decisive rounds to finish on 44 points and book their final berth.',
        timeAgo: '20 hours ago',
        category: 'NEWS',
        readTime: '4 min read',
        isFeatured: true,
      ),
      NewsArticle(
        id: 'art_3',
        title: 'AUGUSCO Books Semi-Final Spot after Commanding Quarter-Final Victory!',
        summary:
            'Two-time champions St. Augustine\'s College proved their pedigree with a 47-point victory in the Quarter-Finals, before defeating Prempeh College (47) and Pope John (28) in Semi-Final 1 to reach their 3rd consecutive Grand Finale.',
        timeAgo: '1 day ago',
        category: 'NEWS',
        readTime: '3 min read',
        isFeatured: false,
      ),
      NewsArticle(
        id: 'art_4',
        title: 'The NSMQ Story: From a Spark of Curiosity to a National Legacy',
        summary:
            'How a March 1993 tennis court discussion at the University of Ghana between Dr. Kwaku Mensa-Bonsu and Prof. Ebenezer Awotwe about why birds don\'t get electrocuted on power lines birthed Ghana\'s most beloved academic championship.',
        timeAgo: '3 days ago',
        category: 'FEATURE',
        readTime: '5 min read',
        isFeatured: false,
      ),
      NewsArticle(
        id: 'art_5',
        title: 'Bright SHS Makes History as First Private Senior High School in NSMQ Semi-Finals',
        summary:
            'In their third appearance at the National Championship, Bright SHS stunned traditional powerhouses to reach the Semi-Finals, scoring a perfect 10/10 in the Problem of the Day and winning the Jupay Clean Sheet Award.',
        timeAgo: '2 days ago',
        category: 'FEATURE',
        readTime: '3 min read',
        isFeatured: false,
      ),
      NewsArticle(
        id: 'art_6',
        title: 'NSMQ 2026: Semi-Final Fixtures & UG Premier Domes Grand Finale Schedule',
        summary:
            'Produced by Primetime Limited and sponsored by GES, GOIL, Prudential Life, and Pepsodent, the 2026 Grand Finale will take place on Thursday, September 10, 2026, at the UG Premier Domes, Legon.',
        timeAgo: '4 days ago',
        category: 'FIXTURES',
        readTime: '2 min read',
        isFeatured: false,
      ),
    ];

    if (category == null || category == 'ALL' || category == 'FOR YOU') {
      return articles;
    }
    return articles
        .where((a) => a.category.toUpperCase() == category.toUpperCase())
        .toList();
  }

  void _initMockPosts() {
    _posts = [
      FeedPost(
        id: 'post_1',
        authorName: 'NSMQ Ghana',
        authorHandle: '@NSMQGhana',
        authorInitials: 'NS',
        authorColor: NeoColors.nsmqRed,
        isVerified: true,
        authorRole: 'OFFICIAL',
        category: 'OFFICIAL',
        crestUrl: SchoolAssets.nsmqLogo,
        timeAgo: '4m',
        content:
            '🚨 OFFICIAL FINAL SCORES • SEMI-FINAL CONTEST 3:\n\n'
            '🟡 Accra Academy: 54 pts\n'
            '🟢 Bright SHS: 44 pts\n'
            '⚪ Achimota School: 41 pts\n\n'
            'HISTORY MADE! Accra Academy clinches their FIRST-EVER NSMQ Grand Finale spot, sweeps GH¢8,800 in awards, and joins PRESEC & AUGUSCO for the ultimate crown! 💛⚡\n\n'
            '#NSMQ2026 #Bleoo #AccraAcademy #NationalChampionship',
        imageUrl: 'https://i.ytimg.com/vi/ls1QJrKe_qY/maxresdefault.jpg',
        imageCaption: 'Accra Academy celebrating historic qualification at UCC Main Auditorium',
        imageAspectRatio: 16 / 9,
        likesCount: 1420,
        commentsCount: 238,
        sharesCount: 512,
        isLiked: false,
        isRetweeted: false,
        comments: const [
          FeedComment(
            id: 'c1_1',
            authorName: 'Kofi Mensah',
            authorHandle: '@kofi_mensah',
            authorInitials: 'KM',
            authorColor: NeoColors.nsmqBlue,
            content: '68 points in 1/8th stage?! Blue Magicians are not playing games this year! 🔥🦁',
            timeAgo: '2m',
            likesCount: 45,
          ),
          FeedComment(
            id: 'c1_2',
            authorName: 'Akosua Frimpong',
            authorHandle: '@akosua_f',
            authorInitials: 'AF',
            authorColor: NeoColors.nsmqElectricBlue,
            content: 'Achimota tried in Round 2, but Presec’s speed in Round 5 was simply untouchable.',
            timeAgo: '1m',
            likesCount: 18,
          ),
        ],
      ),
      FeedPost(
        id: 'post_2',
        authorName: 'NSMQ Ghana',
        authorHandle: '@NSMQGhana',
        authorInitials: 'NS',
        authorColor: NeoColors.nsmqRed,
        isVerified: true,
        authorRole: 'OFFICIAL',
        category: 'POLLS',
        crestUrl: SchoolAssets.nsmqLogo,
        timeAgo: '22m',
        content:
            '⚡ DAILY FAN RIDDLE & PROBLEM OF THE DAY:\n\n'
            'An ideal transformer has 500 turns in the primary coil and 50 turns in the secondary coil. If primary voltage is 240V AC, what is the secondary output voltage?\n\n'
            'Can you solve it before Round 3 buzzer? Test your physics IQ! 👇🔬',
        likesCount: 890,
        commentsCount: 94,
        sharesCount: 130,
        isLiked: false,
        isRetweeted: false,
        poll: const FeedPoll(
          question: 'Secondary output voltage:',
          isQuiz: true,
          explanation: 'Formula: Vs = Vp × (Ns / Np) = 240V × (50 / 500) = 24V AC.',
          totalVotes: 3420,
          options: [
            FeedPollOption(id: 'opt_1', text: 'A) 12V AC', votes: 410, isCorrect: false),
            FeedPollOption(id: 'opt_2', text: 'B) 24V AC', votes: 2390, isCorrect: true),
            FeedPollOption(id: 'opt_3', text: 'C) 48V AC', votes: 480, isCorrect: false),
            FeedPollOption(id: 'opt_4', text: 'D) 2400V AC', votes: 140, isCorrect: false),
          ],
        ),
      ),
    ];
  }
}
