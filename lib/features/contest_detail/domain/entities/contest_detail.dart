import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';

class HeadToHeadMatch {
  final String year;
  final String stage;
  final String winnerSchoolName;
  final Map<String, int> scores;

  const HeadToHeadMatch({
    required this.year,
    required this.stage,
    required this.winnerSchoolName,
    required this.scores,
  });
}

class ContestantLineup {
  final String schoolId;
  final String schoolName;
  final List<String> mainContestants;
  final String? reserveContestant;
  final String? patron;

  const ContestantLineup({
    required this.schoolId,
    required this.schoolName,
    required this.mainContestants,
    this.reserveContestant,
    this.patron,
  });
}

class ContestDetail {
  final Contest contest;
  final String quizMistress;
  final String venue;
  final List<ContestantLineup> lineups;
  final String problemOfTheDaySummary;
  final List<HeadToHeadMatch> headToHead;

  const ContestDetail({
    required this.contest,
    this.quizMistress = 'Prof. Elsie Effah Kaufmann',
    this.venue = 'Saarah-Mensah Auditorium, KNUST, Kumasi',
    required this.lineups,
    this.problemOfTheDaySummary = 'Find the resonant frequency of an RLC series circuit with L=2.5H and C=10μF.',
    required this.headToHead,
  });
}
