/// Centralized API Endpoints configured for future Laravel REST API backend.
/// Allows swapping between local mock data and remote Laravel backend seamlessly.
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL (configurable per environment: dev, staging, prod)
  static const String baseUrl = 'https://api.nsmqflashscore.org/api/v1';

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

  // User Favorites & Notifications
  static const String favorites = '/user/favorites';
}
