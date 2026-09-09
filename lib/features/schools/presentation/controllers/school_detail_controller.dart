import 'package:get/get.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/school.dart';
import '../../domain/entities/school_profile.dart';
import '../../domain/repositories/i_schools_repository.dart';

class SchoolDetailController extends GetxController {
  final ISchoolsRepository repository;

  SchoolDetailController({required this.repository});

  final Rx<SchoolProfile?> profile = Rx<SchoolProfile?>(null);
  final RxList<Contest> matchHistory = <Contest>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is SchoolProfile) {
      profile.value = args;
      isLoading.value = false;
      loadMatchHistory(args.school.id);
    } else if (args is School) {
      loadSchool(args.id, fallbackSchool: args);
    } else if (args is String) {
      loadSchool(args);
    }
  }

  Future<void> loadMatchHistory(String id) async {
    try {
      final history = await repository.getSchoolHistory(id);
      matchHistory.assignAll(history);
    } catch (_) {}
  }

  Future<void> loadSchool(String id, {School? fallbackSchool}) async {
    isLoading.value = true;
    try {
      final p = await repository.getSchoolById(id);
      if (p != null) {
        profile.value = p;
      } else if (fallbackSchool != null) {
        profile.value = SchoolProfile(
          school: fallbackSchool,
          motto: 'Knowledge is Power',
          foundedYear: 'N/A',
          city: fallbackSchool.region,
          championshipYears: const [],
          finalsAppearances: 0,
          totalContestsWon: 0,
          highestScoreRecord: 'N/A',
          notableContestants: const [],
        );
      }
      await loadMatchHistory(id);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    final current = profile.value;
    if (current == null) return;
    await repository.toggleFavorite(current.school.id);
    profile.value = current.copyWith(isFavorite: !current.isFavorite);
  }
}
