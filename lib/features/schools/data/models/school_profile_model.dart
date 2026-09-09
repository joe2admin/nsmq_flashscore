import '../../../live_scores/data/models/school_model.dart';
import '../../domain/entities/school_profile.dart';

class SchoolProfileModel extends SchoolProfile {
  const SchoolProfileModel({
    required super.school,
    required super.motto,
    required super.foundedYear,
    required super.city,
    required super.championshipYears,
    required super.finalsAppearances,
    required super.totalContestsWon,
    required super.highestScoreRecord,
    required super.notableContestants,
    super.isFavorite = false,
  });

  factory SchoolProfileModel.fromJson(Map<String, dynamic> json) {
    final schoolMap = json['school'] as Map<String, dynamic>? ?? json;
    final school = SchoolModel.fromJson(schoolMap);

    final champYearsRaw = json['championship_years'] ?? json['championshipYears'];
    final championshipYears = (champYearsRaw as List<dynamic>?)
            ?.map((e) => int.tryParse(e.toString()) ?? 0)
            .toList() ??
        [];

    final notableRaw = json['notable_contestants'] ?? json['notableContestants'];
    final notableContestants = (notableRaw as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return SchoolProfileModel(
      school: school,
      motto: (json['motto'] as String?) ?? '',
      foundedYear: (json['founded_year'] ?? json['foundedYear'])?.toString() ?? '',
      city: (json['city'] as String?) ?? '',
      championshipYears: championshipYears,
      finalsAppearances: int.tryParse((json['finals_appearances'] ?? json['finalsAppearances'] ?? 0).toString()) ?? 0,
      totalContestsWon: int.tryParse((json['total_contests_won'] ?? json['totalContestsWon'] ?? 0).toString()) ?? 0,
      highestScoreRecord: (json['highest_score_record'] ?? json['highestScoreRecord'])?.toString() ?? '',
      notableContestants: notableContestants,
      isFavorite: (json['is_favorite'] ?? json['isFavorite']) as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school': (school as SchoolModel).toJson(),
      'motto': motto,
      'founded_year': foundedYear,
      'city': city,
      'championship_years': championshipYears,
      'finals_appearances': finalsAppearances,
      'total_contests_won': totalContestsWon,
      'highest_score_record': highestScoreRecord,
      'notable_contestants': notableContestants,
      'is_favorite': isFavorite,
    };
  }
}
