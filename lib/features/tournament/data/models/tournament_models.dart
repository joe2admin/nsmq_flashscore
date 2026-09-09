import '../../domain/entities/tournament_stage.dart';

class StageContestPreviewModel extends StageContestPreview {
  const StageContestPreviewModel({
    required super.id,
    required super.title,
    required super.status,
    required super.schoolNames,
    required super.scores,
    super.winner,
    super.matchLabel,
    super.matchNumber,
    super.nextMatchTarget,
  });

  factory StageContestPreviewModel.fromJson(Map<String, dynamic> json) {
    final schoolNamesRaw = json['school_names'] ?? json['schoolNames'];
    final schoolNames = (schoolNamesRaw as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final scoresRaw = json['scores'];
    final scores = (scoresRaw as List<dynamic>?)
            ?.map((e) => int.tryParse(e.toString()) ?? 0)
            .toList() ??
        [];

    return StageContestPreviewModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? 'Scheduled',
      schoolNames: schoolNames,
      scores: scores,
      winner: json['winner'] as String?,
      matchLabel: (json['match_label'] ?? json['matchLabel']) as String?,
      matchNumber: int.tryParse((json['match_number'] ?? json['matchNumber'] ?? '').toString()),
      nextMatchTarget: int.tryParse((json['next_match_target'] ?? json['nextMatchTarget'] ?? '').toString()),
    );
  }
}

class TournamentStageModel extends TournamentStage {
  const TournamentStageModel({
    required super.id,
    required super.name,
    required super.dateRange,
    super.isCurrent = false,
    super.subtitle = '3 PARTICIPANTS PER MATCH',
    required super.contests,
  });

  factory TournamentStageModel.fromJson(Map<String, dynamic> json) {
    final contestsRaw = json['contests'] as List<dynamic>? ?? [];
    final contests = contestsRaw
        .map((e) => StageContestPreviewModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return TournamentStageModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      dateRange: (json['date_range'] ?? json['dateRange']) as String? ?? '',
      isCurrent: (json['is_current'] ?? json['isCurrent']) as bool? ?? false,
      subtitle: json['subtitle'] as String? ?? '3 PARTICIPANTS PER MATCH',
      contests: contests,
    );
  }
}

class TournamentAwardModel extends TournamentAward {
  const TournamentAwardModel({
    required super.title,
    required super.sponsor,
    required super.prize,
    required super.currentLeader,
    required super.points,
  });

  factory TournamentAwardModel.fromJson(Map<String, dynamic> json) {
    return TournamentAwardModel(
      title: json['title'] as String? ?? '',
      sponsor: json['sponsor'] as String? ?? '',
      prize: json['prize'] as String? ?? '',
      currentLeader: (json['current_leader'] ?? json['currentLeader']) as String? ?? '',
      points: int.tryParse((json['points'] ?? 0).toString()) ?? 0,
    );
  }
}
