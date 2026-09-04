import '../../domain/entities/contest.dart';
import '../../domain/repositories/i_contest_repository.dart';
import '../providers/mock_contest_data.dart';

class ContestRepositoryImpl implements IContestRepository {
  final List<Contest> _contests = MockContestData.getContests();

  @override
  Future<List<Contest>> getContests({
    DateTime? date,
    ContestStatus? status,
    String? stage,
    String? searchQuery,
  }) async {
    // Simulated micro-network latency for realistic async behavior
    await Future.delayed(const Duration(milliseconds: 150));

    return _contests.where((c) {
      // Date filter
      if (date != null) {
        final sameDay = c.scheduledAt.year == date.year &&
            c.scheduledAt.month == date.month &&
            c.scheduledAt.day == date.day;
        if (!sameDay) return false;
      }

      // Status filter
      if (status != null && c.status != status) {
        return false;
      }

      // Stage filter
      if (stage != null && stage != 'All Stages' && c.stage != stage) {
        return false;
      }

      // Search query filter
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        final matchesTitle = c.title.toLowerCase().contains(query);
        final matchesStage = c.stage.toLowerCase().contains(query);
        final matchesSchool = c.entries.any((e) =>
            e.school.name.toLowerCase().contains(query) ||
            e.school.shortName.toLowerCase().contains(query));
        if (!matchesTitle && !matchesStage && !matchesSchool) return false;
      }

      return true;
    }).toList();
  }

  @override
  Future<Contest?> getContestById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _contests.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
