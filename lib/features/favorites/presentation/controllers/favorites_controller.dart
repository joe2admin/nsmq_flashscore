import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import 'package:nsmq_flashscore/features/live_scores/data/models/contest_model.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/repositories/i_contest_repository.dart';
import 'package:nsmq_flashscore/features/schools/data/models/school_profile_model.dart';
import 'package:nsmq_flashscore/features/schools/domain/entities/school_profile.dart';
import 'package:nsmq_flashscore/features/schools/domain/repositories/i_schools_repository.dart';

class FavoritesController extends GetxController {
  final ISchoolsRepository schoolsRepository;
  final IContestRepository contestRepository;
  final ApiClient _apiClient;

  FavoritesController({
    required this.schoolsRepository,
    required this.contestRepository,
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? (Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : ApiClient());

  final RxList<SchoolProfile> favoriteSchools = <SchoolProfile>[].obs;
  final RxList<Contest> favoriteMatches = <Contest>[].obs;
  final RxBool isLoading = true.obs;

  // Notification Preferences
  final RxBool alertLiveRounds = true.obs;
  final RxBool alertProblemOfDay = true.obs;
  final RxBool alertFinalScores = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    try {
      final response = await _apiClient.safeGet(ApiEndpoints.favorites);
      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;
        if (dataRaw is Map) {
          final schoolsRaw = dataRaw['schools'] as List? ?? [];
          final matchesRaw = dataRaw['matches'] as List? ?? [];
          final prefsRaw = dataRaw['preferences'] as Map? ?? {};

          favoriteSchools.assignAll(schoolsRaw
              .map((s) => SchoolProfileModel.fromJson(s as Map<String, dynamic>))
              .toList());

          favoriteMatches.assignAll(matchesRaw
              .map((m) => ContestModel.fromJson(m as Map<String, dynamic>))
              .toList());

          if (prefsRaw.isNotEmpty) {
            alertLiveRounds.value = prefsRaw['alert_live_rounds'] as bool? ?? true;
            alertProblemOfDay.value = prefsRaw['alert_problem_of_day'] as bool? ?? true;
            alertFinalScores.value = prefsRaw['alert_final_scores'] as bool? ?? true;
          }

          if (showLoading) {
            isLoading.value = false;
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('[FavoritesController] loadFavorites API error: $e');
    }

    // Fallback if API not available or empty
    final favSchools = await schoolsRepository.getFavoriteSchools();
    favoriteSchools.assignAll(favSchools);

    final favSchoolNames = favSchools
        .map((s) => s.school.shortName.toLowerCase())
        .toSet();

    final allContests = await contestRepository.getContests();
    final filteredMatches = allContests.where((c) {
      return c.entries.any((e) =>
          favSchoolNames.contains(e.school.shortName.toLowerCase()) ||
          favSchoolNames.contains(e.school.name.toLowerCase()));
    }).toList();

    favoriteMatches.assignAll(filteredMatches);
    if (showLoading) {
      isLoading.value = false;
    }
  }

  Future<void> refreshFavorites() async {
    await loadFavorites(showLoading: false);
  }

  Future<void> updatePreference({bool? liveRounds, bool? problemOfDay, bool? finalScores}) async {
    if (liveRounds != null) alertLiveRounds.value = liveRounds;
    if (problemOfDay != null) alertProblemOfDay.value = problemOfDay;
    if (finalScores != null) alertFinalScores.value = finalScores;

    try {
      await _apiClient.safePost(ApiEndpoints.userPreferences, {
        'alert_live_rounds': alertLiveRounds.value,
        'alert_problem_of_day': alertProblemOfDay.value,
        'alert_final_scores': alertFinalScores.value,
      });
    } catch (e) {
      debugPrint('[FavoritesController] updatePreference error: $e');
    }
  }

  Future<void> removeFavorite(String schoolId) async {
    await schoolsRepository.toggleFavorite(schoolId);
    loadFavorites();
  }
}
