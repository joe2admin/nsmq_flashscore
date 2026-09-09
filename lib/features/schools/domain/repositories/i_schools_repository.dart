import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';
import 'package:nsmq_flashscore/features/schools/domain/entities/school_profile.dart';

abstract class ISchoolsRepository {
  Future<List<SchoolProfile>> getSchools({
    String? searchQuery,
    String? region,
    bool onlyChampions = false,
  });

  Future<SchoolProfile?> getSchoolById(String id);
  Future<void> toggleFavorite(String id);
  Future<List<SchoolProfile>> getFavoriteSchools();
  Future<List<Contest>> getSchoolHistory(String id);
}
