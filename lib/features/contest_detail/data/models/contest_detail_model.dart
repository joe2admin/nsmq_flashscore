import '../../../live_scores/data/models/contest_model.dart';
import '../../domain/entities/contest_detail.dart';

class HeadToHeadMatchModel extends HeadToHeadMatch {
  const HeadToHeadMatchModel({
    required super.year,
    required super.stage,
    required super.winnerSchoolName,
    required super.scores,
  });

  factory HeadToHeadMatchModel.fromJson(Map<String, dynamic> json) {
    final scoresRaw = json['scores'] as Map<String, dynamic>? ?? {};
    final scores = scoresRaw.map((k, v) => MapEntry(k, int.tryParse(v.toString()) ?? 0));

    return HeadToHeadMatchModel(
      year: json['year']?.toString() ?? '',
      stage: json['stage']?.toString() ?? '',
      winnerSchoolName: (json['winner_school_name'] ?? json['winnerSchoolName'])?.toString() ?? '',
      scores: scores,
    );
  }
}

class ContestantLineupModel extends ContestantLineup {
  const ContestantLineupModel({
    required super.schoolId,
    required super.schoolName,
    required super.mainContestants,
    super.reserveContestant,
    super.patron,
  });

  factory ContestantLineupModel.fromJson(Map<String, dynamic> json) {
    final mainRaw = json['main_contestants'] ?? json['mainContestants'];
    final mainContestants = (mainRaw as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return ContestantLineupModel(
      schoolId: (json['school_id'] ?? json['schoolId'])?.toString() ?? '',
      schoolName: (json['school_name'] ?? json['schoolName'])?.toString() ?? '',
      mainContestants: mainContestants,
      reserveContestant: (json['reserve_contestant'] ?? json['reserveContestant']) as String?,
      patron: json['patron'] as String?,
    );
  }
}

class ContestDetailModel extends ContestDetail {
  const ContestDetailModel({
    required super.contest,
    super.quizMistress = 'Prof. Elsie Effah Kaufmann',
    super.venue = 'Saarah-Mensah Auditorium, KNUST, Kumasi',
    required super.lineups,
    super.problemOfTheDaySummary = '',
    required super.headToHead,
  });

  factory ContestDetailModel.fromJson(Map<String, dynamic> json) {
    final contestMap = json['contest'] as Map<String, dynamic>? ?? json;
    final contest = ContestModel.fromJson(contestMap);

    final lineupsRaw = json['lineups'] as List<dynamic>? ?? [];
    final lineups = lineupsRaw
        .map((e) => ContestantLineupModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final h2hRaw = (json['head_to_head'] ?? json['headToHead']) as List<dynamic>? ?? [];
    final headToHead = h2hRaw
        .map((e) => HeadToHeadMatchModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ContestDetailModel(
      contest: contest,
      quizMistress: (json['quiz_mistress'] ?? json['quizMistress']) as String? ?? 'Prof. Elsie Effah Kaufmann',
      venue: (json['venue']) as String? ?? 'Saarah-Mensah Auditorium, KNUST, Kumasi',
      lineups: lineups,
      problemOfTheDaySummary: (json['problem_of_the_day_summary'] ?? json['problemOfTheDaySummary']) as String? ?? '',
      headToHead: headToHead,
    );
  }
}
