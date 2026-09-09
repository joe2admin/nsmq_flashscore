import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import 'package:nsmq_flashscore/features/live_scores/data/providers/mock_contest_data.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';
import '../models/contest_detail_model.dart';
import '../../domain/entities/contest_detail.dart';
import '../../domain/repositories/i_contest_detail_repository.dart';

class ContestDetailRepositoryImpl implements IContestDetailRepository {
  final ApiClient _apiClient;

  ContestDetailRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? (Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : ApiClient());

  @override
  Future<ContestDetail> getContestDetail(String contestId) async {
    try {
      final response = await _apiClient.safeGet(ApiEndpoints.contestDetail(contestId));
      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;
        if (dataRaw is Map<String, dynamic>) {
          return ContestDetailModel.fromJson(dataRaw);
        }
      }
    } catch (e) {
      debugPrint('[ContestDetailRepositoryImpl] Backend error, falling back to mock: $e');
    }

    // Fallback to authentic mock detail
    final allContests = MockContestData.getContests();
    Contest contest;
    try {
      contest = allContests.firstWhere((c) => c.id == contestId);
    } catch (_) {
      contest = allContests.first;
    }

    final lineups = contest.entries.map((entry) {
      final name = entry.school.shortName.isNotEmpty
          ? entry.school.shortName
          : entry.school.name;

      if (name.contains('PRESEC')) {
        return ContestantLineup(
          schoolId: entry.school.id,
          schoolName: entry.school.shortName,
          mainContestants: const ['Kwabena Mantey', 'Selorm Ohene-Amoani'],
          reserveContestant: 'Emmanuel Nyarko',
          patron: 'Mr. Dzineku',
        );
      } else if (name.contains('PREMPEH')) {
        return ContestantLineup(
          schoolId: entry.school.id,
          schoolName: entry.school.shortName,
          mainContestants: const ['Stephen Apem-Darko', 'Abdul Majeed'],
          reserveContestant: 'Kofi Mensah Bonsu',
          patron: 'Mr. Peter Agyeman',
        );
      } else if (name.contains('MFANTSIPIM')) {
        return ContestantLineup(
          schoolId: entry.school.id,
          schoolName: entry.school.shortName,
          mainContestants: const ['Peter Hammond', 'Kojo Blankson'],
          reserveContestant: 'Kwesi Arthur',
          patron: 'Rev. J. C. Mensah',
        );
      } else if (name.contains('KETA')) {
        return ContestantLineup(
          schoolId: entry.school.id,
          schoolName: entry.school.shortName,
          mainContestants: const ['Francisca Lamini', 'James Lutterodt'],
          reserveContestant: 'Bright Senyo',
          patron: 'Mr. K. Agbemenya',
        );
      } else {
        return ContestantLineup(
          schoolId: entry.school.id,
          schoolName: entry.school.shortName,
          mainContestants: const ['Benjamin Osei', 'Prince Boateng'],
          reserveContestant: 'David Appiah',
          patron: 'Mr. S. Addo',
        );
      }
    }).toList();

    return ContestDetail(
      contest: contest,
      quizMistress: 'Prof. Elsie Effah Kaufmann',
      venue: 'Saarah-Mensah Auditorium, KNUST, Kumasi',
      lineups: lineups,
      problemOfTheDaySummary:
          'Calculate the total electromotive force induced in a 200-turn circular loop of radius 0.05m rotating in a uniform magnetic field of 0.4T at 50 rad/s.',
      headToHead: const [
        HeadToHeadMatch(
          year: '2023',
          stage: 'Grand Finale',
          winnerSchoolName: 'PRESEC LEGON',
          scores: {'PRESEC': 40, 'PREMPEH': 37, 'MFANTSIPIM': 28},
        ),
        HeadToHeadMatch(
          year: '2022',
          stage: 'Semi-Finals',
          winnerSchoolName: 'PRESEC LEGON',
          scores: {'PRESEC': 51, 'PREMPEH': 49, 'KETA SHTS': 32},
        ),
        HeadToHeadMatch(
          year: '2021',
          stage: 'Quarter-Finals',
          winnerSchoolName: 'PREMPEH',
          scores: {'PREMPEH': 46, 'PRESEC': 43, 'OWASS': 35},
        ),
      ],
    );
  }
}
