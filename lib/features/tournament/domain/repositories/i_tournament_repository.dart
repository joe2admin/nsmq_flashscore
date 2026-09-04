import '../entities/tournament_stage.dart';

abstract class ITournamentRepository {
  Future<List<TournamentStage>> getStages();
  Future<List<TournamentAward>> getAwards();
}
