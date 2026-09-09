/// Centralized API Endpoints configured for future Laravel REST API backend.
/// Allows swapping between local mock data and remote Laravel backend seamlessly.
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL (configurable per environment: dev, staging, prod)
  static const String baseUrl = 'http://10.16.69.217:8000/api/v1';

  // Contests / Matches Endpoints
  static const String contests = '/contests';
  static String contestDetail(String id) => '/contests/$id';
  static String contestRounds(String id) => '/contests/$id/rounds';
  static const String liveContests = '/contests/live';

  // Tournament Stages & Brackets
  static const String tournamentStages = '/tournament/stages';
  static String stageBrackets(String stageId) => '/tournament/stages/$stageId/brackets';
  static const String awards = '/tournament/awards';

  // Schools Directory & Stats
  static const String schools = '/schools';
  static String schoolDetail(String id) => '/schools/$id';
  static String schoolHistory(String id) => '/schools/$id/history';

  // News & Feed
  static const String news = '/news';
  static String newsDetail(String id) => '/news/$id';
  static const String problemOfTheDay = '/news/problem-of-the-day';
  static const String feed = '/news/feed';
  static String feedLike(String id) => '/news/feed/$id/like';
  static String feedRetweet(String id) => '/news/feed/$id/retweet';
  static String feedBookmark(String id) => '/news/feed/$id/bookmark';
  static String feedComments(String id) => '/news/feed/$id/comments';
  static String feedCommentLike(String postId, String commentId) => '/news/feed/$postId/comments/$commentId/like';
  static String feedVote(String id) => '/news/feed/$id/poll/vote';

  // User Favorites & Notifications
  static const String favorites = '/user/favorites';
  static const String userPreferences = '/user/preferences';
  static String schoolFavorite(String id) => '/schools/$id/favorite';
}
