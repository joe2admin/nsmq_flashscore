class StageContestPreview {
  final String id;
  final String title;
  final String status;
  final List<String> schoolNames;
  final List<int> scores;
  final String? winner;
  final String? matchLabel;
  final int? matchNumber;
  final int? nextMatchTarget;

  const StageContestPreview({
    required this.id,
    required this.title,
    required this.status,
    required this.schoolNames,
    required this.scores,
    this.winner,
    this.matchLabel,
    this.matchNumber,
    this.nextMatchTarget,
  });

  String get displayLabel => matchLabel ?? title.toUpperCase();
}

class TournamentAward {
  final String title;
  final String sponsor;
  final String prize;
  final String currentLeader;
  final int points;

  const TournamentAward({
    required this.title,
    required this.sponsor,
    required this.prize,
    required this.currentLeader,
    required this.points,
  });
}

class TournamentStage {
  final String id;
  final String name;
  final String dateRange;
  final bool isCurrent;
  final String subtitle;
  final List<StageContestPreview> contests;

  const TournamentStage({
    required this.id,
    required this.name,
    required this.dateRange,
    this.isCurrent = false,
    this.subtitle = '3 PARTICIPANTS PER MATCH',
    required this.contests,
  });
}
