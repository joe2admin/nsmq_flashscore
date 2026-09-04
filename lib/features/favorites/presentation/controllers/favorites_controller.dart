import 'package:get/get.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/repositories/i_contest_repository.dart';
import 'package:nsmq_flashscore/features/schools/domain/entities/school_profile.dart';
import 'package:nsmq_flashscore/features/schools/domain/repositories/i_schools_repository.dart';

class FavoritesController extends GetxController {
  final ISchoolsRepository schoolsRepository;
  final IContestRepository contestRepository;

  FavoritesController({
    required this.schoolsRepository,
    required this.contestRepository,
  });

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

  Future<void> loadFavorites() async {
    isLoading.value = true;
    try {
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFavorite(String schoolId) async {
    await schoolsRepository.toggleFavorite(schoolId);
    loadFavorites();
  }
}
