import 'school.dart';
import 'round_scores.dart';

enum ContestStatus {
  scheduled,
  live,
  finished,
}

/// A school competing in a specific contest with its current scores
class ContestantEntry {
  final School school;
  final RoundScores scores;
  final bool isWinner;

  const ContestantEntry({
    required this.school,
    required this.scores,
    this.isWinner = false,
  });
}

/// Represents an NSMQ Contest typically featuring 3 schools
class Contest {
  final String id;
  final String title;         // e.g. "Contest 14"
  final String stage;         // e.g. "One-Eighth Stage"
  final DateTime scheduledAt;
  final ContestStatus status;
  final int currentRound;     // 1 to 5 (or 0 if scheduled)
  final String currentRoundName; // e.g. "Round 3: Problem of the Day"
  final List<ContestantEntry> entries; // Typically 3 schools
  final String? liveAudioUrl; // Live radio / commentary audio stream URL

  const Contest({
    required this.id,
    required this.title,
    required this.stage,
    required this.scheduledAt,
    required this.status,
    this.currentRound = 0,
    this.currentRoundName = '',
    required this.entries,
    this.liveAudioUrl,
  });

  /// Highest total points among contestants in this contest
  int get highestScore {
    if (entries.isEmpty) return 0;
    return entries.map((e) => e.scores.total).reduce((a, b) => a > b ? a : b);
  }

  /// Finds the school(s) currently leading with the highest score
  List<ContestantEntry> get leaders {
    if (entries.isEmpty) return [];
    final max = highestScore;
    return entries.where((e) => e.scores.total == max).toList();
  }

  /// Checks if a school is currently leading (or tied for the lead)
  bool isSchoolLeader(String schoolId) {
    if (entries.isEmpty) return false;
    final max = highestScore;
    return entries.any((e) => e.school.id == schoolId && e.scores.total == max);
  }

  /// Finds the school currently leading in total points
  ContestantEntry? get leader {
    if (entries.isEmpty) return null;
    return entries.reduce(
      (a, b) => a.scores.total >= b.scores.total ? a : b,
    );
  }
}
