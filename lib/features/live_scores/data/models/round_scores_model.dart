import '../../domain/entities/round_scores.dart';

/// RoundScores data model with Laravel JSON serialization
class RoundScoresModel extends RoundScores {
  const RoundScoresModel({
    super.r1,
    super.r2,
    super.r3,
    super.r4,
    super.r5,
    super.penalties,
  });

  factory RoundScoresModel.fromJson(Map<String, dynamic> json) {
    return RoundScoresModel(
      r1: json['r1'] as int? ?? 0,
      r2: json['r2'] as int? ?? 0,
      r3: json['r3'] as int? ?? 0,
      r4: json['r4'] as int? ?? 0,
      r5: json['r5'] as int? ?? 0,
      penalties: json['penalties'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'r1': r1,
      'r2': r2,
      'r3': r3,
      'r4': r4,
      'r5': r5,
      'penalties': penalties,
      'total': total,
    };
  }
}
