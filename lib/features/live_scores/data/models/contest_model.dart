import '../../domain/entities/contest.dart';
import 'school_model.dart';
import 'round_scores_model.dart';

/// Contest data model with Laravel JSON serialization
class ContestantEntryModel extends ContestantEntry {
  const ContestantEntryModel({
    required super.school,
    required super.scores,
    super.isWinner,
  });

  factory ContestantEntryModel.fromJson(Map<String, dynamic> json) {
    return ContestantEntryModel(
      school: SchoolModel.fromJson(json['school'] as Map<String, dynamic>),
      scores: RoundScoresModel.fromJson(json['scores'] as Map<String, dynamic>),
      isWinner: json['is_winner'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school': (school as SchoolModel).toJson(),
      'scores': (scores as RoundScoresModel).toJson(),
      'is_winner': isWinner,
    };
  }
}

class ContestModel extends Contest {
  const ContestModel({
    required super.id,
    required super.title,
    required super.stage,
    required super.scheduledAt,
    required super.status,
    super.currentRound,
    super.currentRoundName,
    required super.entries,
    super.liveAudioUrl,
  });

  factory ContestModel.fromJson(Map<String, dynamic> json) {
    ContestStatus status;
    switch (json['status']?.toString().toLowerCase()) {
      case 'live':
        status = ContestStatus.live;
        break;
      case 'finished':
        status = ContestStatus.finished;
        break;
      case 'scheduled':
      default:
        status = ContestStatus.scheduled;
        break;
    }

    final entriesJson = json['entries'] as List<dynamic>? ?? [];
    final entries = entriesJson
        .map((e) => ContestantEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ContestModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      stage: json['stage'] as String? ?? '',
      scheduledAt: DateTime.tryParse(json['scheduled_at']?.toString() ?? '') ?? DateTime.now(),
      status: status,
      currentRound: json['current_round'] as int? ?? 0,
      currentRoundName: json['current_round_name'] as String? ?? '',
      entries: entries,
      liveAudioUrl: json['live_audio_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'stage': stage,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status.name,
      'current_round': currentRound,
      'current_round_name': currentRoundName,
      'live_audio_url': liveAudioUrl,
      'entries': entries.map((e) {
        if (e is ContestantEntryModel) return e.toJson();
        return ContestantEntryModel(
          school: SchoolModel(
            id: e.school.id,
            name: e.school.name,
            shortName: e.school.shortName,
            region: e.school.region,
            crestUrl: e.school.crestUrl,
            titlesCount: e.school.titlesCount,
          ),
          scores: RoundScoresModel(
            r1: e.scores.r1,
            r2: e.scores.r2,
            r3: e.scores.r3,
            r4: e.scores.r4,
            r5: e.scores.r5,
            penalties: e.scores.penalties,
          ),
          isWinner: e.isWinner,
        ).toJson();
      }).toList(),
    };
  }
}
