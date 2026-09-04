import 'package:nsmq_flashscore/features/live_scores/domain/entities/school.dart';

class SchoolProfile {
  final School school;
  final String motto;
  final String foundedYear;
  final String city;
  final List<int> championshipYears;
  final int finalsAppearances;
  final int totalContestsWon;
  final String highestScoreRecord;
  final List<String> notableContestants;
  final bool isFavorite;

  const SchoolProfile({
    required this.school,
    required this.motto,
    required this.foundedYear,
    required this.city,
    required this.championshipYears,
    required this.finalsAppearances,
    required this.totalContestsWon,
    required this.highestScoreRecord,
    required this.notableContestants,
    this.isFavorite = false,
  });

  SchoolProfile copyWith({
    bool? isFavorite,
  }) {
    return SchoolProfile(
      school: school,
      motto: motto,
      foundedYear: foundedYear,
      city: city,
      championshipYears: championshipYears,
      finalsAppearances: finalsAppearances,
      totalContestsWon: totalContestsWon,
      highestScoreRecord: highestScoreRecord,
      notableContestants: notableContestants,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
