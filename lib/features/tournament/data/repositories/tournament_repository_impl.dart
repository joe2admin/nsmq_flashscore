import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/tournament_models.dart';
import '../../domain/entities/tournament_stage.dart';
import '../../domain/repositories/i_tournament_repository.dart';

class TournamentRepositoryImpl implements ITournamentRepository {
  final ApiClient _apiClient;

  TournamentRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? (Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : ApiClient());

  @override
  Future<List<TournamentStage>> getStages() async {
    try {
      final response = await _apiClient.safeGet(ApiEndpoints.tournamentStages);
      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;
        if (dataRaw is List) {
          return dataRaw
              .map((e) => TournamentStageModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('[TournamentRepositoryImpl] getStages backend error, falling back to mock: $e');
    }

    // Fallback to static stages
    return const [
      TournamentStage(
        id: 'stage_prelims',
        name: 'Preliminary Round',
        dateRange: 'Oct 10 - Oct 13, 2026',
        subtitle: '3 PARTICIPANTS PER MATCH',
        contests: [
          StageContestPreview(
            id: 'c_prelim_1',
            matchLabel: 'MATCH 1',
            title: 'Prelims Match 1',
            status: 'Finished',
            schoolNames: ['ST. THOMAS AQUINAS', 'GHANA NATIONAL', 'OGUAA SHTS'],
            scores: [48, 38, 22],
            winner: 'ST. THOMAS AQUINAS',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'c_prelim_2',
            matchLabel: 'MATCH 2',
            title: 'Prelims Match 2',
            status: 'Finished',
            schoolNames: ['APAM SHS', 'POPE JOHN SEMINARY', 'T.I. AMASS'],
            scores: [35, 52, 41],
            winner: 'POPE JOHN SEMINARY',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'c_prelim_3',
            matchLabel: 'MATCH 3',
            title: 'Prelims Match 3',
            status: 'Finished',
            schoolNames: ['KROBO GIRLS', 'NOTRE DAME SEMINARY', 'OPOKU WARE'],
            scores: [28, 33, 58],
            winner: 'OPOKU WARE',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'c_prelim_4',
            matchLabel: 'MATCH 4',
            title: 'Prelims Match 4',
            status: 'Finished',
            schoolNames: ['KETA SHTS', 'KASS', 'BISHOP HERMAN'],
            scores: [54, 39, 27],
            winner: 'KETA SHTS',
            nextMatchTarget: 2,
          ),
          StageContestPreview(
            id: 'c_prelim_5',
            matchLabel: 'MATCH 5',
            title: 'Prelims Match 5',
            status: 'Finished',
            schoolNames: ['TAMALE SHS', 'SWEDRU SHS', 'OLA GIRLS'],
            scores: [46, 31, 24],
            winner: 'TAMALE SHS',
            nextMatchTarget: 2,
          ),
          StageContestPreview(
            id: 'c_prelim_6',
            matchLabel: 'MATCH 6',
            title: 'Prelims Match 6',
            status: 'Finished',
            schoolNames: ['ACHIMOTA SCHOOL', 'KUMASI HIGH', 'SUNYANI SHS'],
            scores: [51, 44, 29],
            winner: 'ACHIMOTA SCHOOL',
            nextMatchTarget: 2,
          ),
        ],
      ),
      TournamentStage(
        id: 'stage_one_eighth',
        name: 'One-Eighth Stage',
        dateRange: 'Oct 14 - Oct 17, 2026',
        subtitle: '3 PARTICIPANTS PER MATCH',
        contests: [
          StageContestPreview(
            id: 'c_oe_1',
            matchLabel: 'MATCH 1',
            title: 'One-Eighth 1',
            status: 'Finished',
            schoolNames: ['PRESEC LEGON', 'ACCRA ACADEMY', 'KUMASI ACADEMY'],
            scores: [65, 34, 22],
            winner: 'PRESEC LEGON',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'c_oe_2',
            matchLabel: 'MATCH 2',
            title: 'One-Eighth 2',
            status: 'Finished',
            schoolNames: ['MFANTSIPIM', 'ST. AUGUSTINE\'S', 'POJOSS'],
            scores: [53, 45, 31],
            winner: 'MFANTSIPIM',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'c_oe_3',
            matchLabel: 'MATCH 3',
            title: 'One-Eighth 3',
            status: 'Finished',
            schoolNames: ['WESLEY GIRLS', 'ST. THOMAS AQUINAS', 'ABURI GIRLS'],
            scores: [44, 38, 25],
            winner: 'WESLEY GIRLS',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'c_oe_4',
            matchLabel: 'MATCH 4',
            title: 'One-Eighth 4',
            status: 'Finished',
            schoolNames: ['PREMPEH', 'ADISADEL', 'TAMALE SHS'],
            scores: [63, 42, 28],
            winner: 'PREMPEH',
            nextMatchTarget: 2,
          ),
          StageContestPreview(
            id: 'c_oe_5',
            matchLabel: 'MATCH 5',
            title: 'One-Eighth 5',
            status: 'Finished',
            schoolNames: ['OWASS', 'KETA SHTS', 'ACHIMOTA'],
            scores: [59, 48, 36],
            winner: 'OWASS',
            nextMatchTarget: 2,
          ),
          StageContestPreview(
            id: 'c_oe_6',
            matchLabel: 'MATCH 6',
            title: 'One-Eighth 6',
            status: 'Finished',
            schoolNames: ['ST. PETER\'S', 'KUHIS', 'MAWULI SCHOOL'],
            scores: [50, 41, 30],
            winner: 'ST. PETER\'S',
            nextMatchTarget: 2,
          ),
        ],
      ),
      TournamentStage(
        id: 'stage_quarters',
        name: 'Quarter Finals',
        dateRange: 'Aug 30 - Sep 1, 2026',
        subtitle: '3 PARTICIPANTS PER MATCH',
        contests: [
          StageContestPreview(
            id: 'c_qf_1',
            matchLabel: 'QF 1',
            title: 'Quarter-Final 1',
            status: 'Finished',
            schoolNames: ['PREMPEH COLLEGE', 'KETA SHTS', 'GHANA NATIONAL'],
            scores: [44, 39, 30],
            winner: 'PREMPEH COLLEGE',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'c_qf_2',
            matchLabel: 'QF 2',
            title: 'Quarter-Final 2',
            status: 'Finished',
            schoolNames: ['POPE JOHN SHS', 'OFORI PANIN SHS', 'OSEI TUTU SHS'],
            scores: [47, 31, 22],
            winner: 'POPE JOHN SHS',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'c_qf_3',
            matchLabel: 'QF 3',
            title: 'Quarter-Final 3',
            status: 'Finished',
            schoolNames: ['ST. AUGUSTINE\'S', 'ST. JOHN\'S GRAMMAR', 'ABURI GIRLS\''],
            scores: [47, 27, 25],
            winner: 'ST. AUGUSTINE\'S',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'c_qf_4',
            matchLabel: 'QF 4',
            title: 'Quarter-Final 4',
            status: 'Finished',
            schoolNames: ['TAMALE SHS', 'ST. HUBERT SEMINARY', 'LABONE SHS'],
            scores: [36, 33, 14],
            winner: 'TAMALE SHS',
            nextMatchTarget: 2,
          ),
          StageContestPreview(
            id: 'c_qf_5',
            matchLabel: 'QF 5',
            title: 'Quarter-Final 5',
            status: 'Finished',
            schoolNames: ['ST. JOHN\'S SCHOOL', 'SAVIOUR SHS', 'MFANTSIMAN GIRLS\''],
            scores: [43, 33, 25],
            winner: 'ST. JOHN\'S SCHOOL',
            nextMatchTarget: 2,
          ),
          StageContestPreview(
            id: 'c_qf_6',
            matchLabel: 'QF 6',
            title: 'Quarter-Final 6',
            status: 'Finished',
            schoolNames: ['PRESEC LEGON', 'MFANTSIPIM SCHOOL', 'PRESBY SHS, BOMPATA'],
            scores: [56, 39, 24],
            winner: 'PRESEC LEGON',
            nextMatchTarget: 2,
          ),
          StageContestPreview(
            id: 'c_qf_7',
            matchLabel: 'QF 7',
            title: 'Quarter-Final 7',
            status: 'Finished',
            schoolNames: ['BRIGHT SHS', 'CHEMU SHTS', 'AMANIAMPONG SHS'],
            scores: [27, 26, 22],
            winner: 'BRIGHT SHS',
            nextMatchTarget: 3,
          ),
          StageContestPreview(
            id: 'c_qf_8',
            matchLabel: 'QF 8',
            title: 'Quarter-Final 8',
            status: 'Finished',
            schoolNames: ['ACHIMOTA SCHOOL', 'ADISADEL COLLEGE', 'BOA AMPONSEM SHS'],
            scores: [55, 28, 23],
            winner: 'ACHIMOTA SCHOOL',
            nextMatchTarget: 3,
          ),
          StageContestPreview(
            id: 'c_qf_9',
            matchLabel: 'QF 9',
            title: 'Quarter-Final 9',
            status: 'Finished',
            schoolNames: ['ACCRA ACADEMY', 'UNIVERSITY PRACTICE', 'BISHOP HERMAN'],
            scores: [23, 20, 17],
            winner: 'ACCRA ACADEMY',
            nextMatchTarget: 3,
          ),
        ],
      ),
      TournamentStage(
        id: 'stage_semis',
        name: 'Semi Finals',
        dateRange: 'September 3, 2026',
        subtitle: '3 PARTICIPANTS PER MATCH',
        isCurrent: true,
        contests: [
          StageContestPreview(
            id: 'contest_fin_sf1',
            matchLabel: 'SF MATCH 1',
            title: 'Semi-Final 1',
            status: 'Finished',
            schoolNames: ['ST. AUGUSTINE\'S', 'PREMPEH COLLEGE', 'POPE JOHN SHS'],
            scores: [52, 47, 28],
            winner: 'ST. AUGUSTINE\'S',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'contest_fin_sf2',
            matchLabel: 'SF MATCH 2',
            title: 'Semi-Final 2',
            status: 'Finished',
            schoolNames: ['PRESEC LEGON', 'ST. JOHN\'S SCHOOL', 'TAMALE SHS'],
            scores: [44, 25, 16],
            winner: 'PRESEC LEGON',
            nextMatchTarget: 1,
          ),
          StageContestPreview(
            id: 'contest_fin_sf3',
            matchLabel: 'SF MATCH 3',
            title: 'Semi-Final 3',
            status: 'Finished',
            schoolNames: ['ACCRA ACADEMY', 'BRIGHT SHS', 'ACHIMOTA SCHOOL'],
            scores: [54, 44, 41],
            winner: 'ACCRA ACADEMY',
            nextMatchTarget: 1,
          ),
        ],
      ),
      TournamentStage(
        id: 'stage_finale',
        name: 'Grand Finale',
        dateRange: 'September 10, 2026',
        subtitle: '3 PARTICIPANTS PER MATCH',
        isCurrent: false,
        contests: [
          StageContestPreview(
            id: 'contest_sched_106',
            matchLabel: 'GRAND FINALE MATCH',
            title: '2026 National Championship',
            status: 'Upcoming',
            schoolNames: ['ST. AUGUSTINE\'S', 'PRESEC LEGON', 'ACCRA ACADEMY'],
            scores: [0, 0, 0],
          ),
        ],
      ),
    ];
  }

  @override
  Future<List<TournamentAward>> getAwards() async {
    try {
      final response = await _apiClient.safeGet(ApiEndpoints.awards);
      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;
        if (dataRaw is List) {
          return dataRaw
              .map((e) => TournamentAwardModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('[TournamentRepositoryImpl] getAwards backend error, falling back to mock: $e');
    }

    return const [
      TournamentAward(
        title: 'Pepsodent Highest Scorer Award',
        sponsor: 'Pepsodent Ghana',
        prize: 'GH¢3,000',
        currentLeader: 'PRESEC LEGON',
        points: 56,
      ),
      TournamentAward(
        title: 'Prudential Life NSMQ Star',
        sponsor: 'Prudential Life Insurance',
        prize: 'GH¢3,400 (Perfect 10/10)',
        currentLeader: 'ACCRA ACADEMY • BRIGHT SHS • ACHIMOTA',
        points: 10,
      ),
      TournamentAward(
        title: 'Jupay Clean Sheet Award',
        sponsor: 'Jupay Money Transfer',
        prize: 'GH¢1,500 (R4 Flawless)',
        currentLeader: 'BRIGHT SHS',
        points: 16,
      ),
      TournamentAward(
        title: 'GOIL Super Bonanza',
        sponsor: 'GOIL PLC',
        prize: 'GH¢2,000 (Riddle Sweep)',
        currentLeader: 'PRESEC LEGON',
        points: 9,
      ),
    ];
  }
}
