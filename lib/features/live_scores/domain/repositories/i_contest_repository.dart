import '../entities/contest.dart';

abstract class IContestRepository {
  Future<List<Contest>> getContests({
    DateTime? date,
    ContestStatus? status,
    String? stage,
    String? searchQuery,
  });

  Future<Contest?> getContestById(String id);
}
