import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nsmq_flashscore/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:nsmq_flashscore/features/live_scores/data/repositories/contest_repository_impl.dart';
import 'package:nsmq_flashscore/features/schools/data/repositories/schools_repository_impl.dart';
import 'package:nsmq_flashscore/features/schools/presentation/controllers/schools_controller.dart';
import 'package:nsmq_flashscore/features/shell/presentation/controllers/navigation_controller.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  group('School Favoriting In-Place & Sync Tests', () {
    test('SchoolsController.toggleFavorite updates school in-place without setting isLoading to true', () async {
      final schoolsRepo = SchoolsRepositoryImpl();
      final contestRepo = ContestRepositoryImpl();

      Get.put<NavigationController>(NavigationController());
      final favCtrl = Get.put<FavoritesController>(
        FavoritesController(schoolsRepository: schoolsRepo, contestRepository: contestRepo),
      );
      final schoolsCtrl = Get.put<SchoolsController>(
        SchoolsController(repository: schoolsRepo),
      );

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 50));
      expect(schoolsCtrl.isLoading.value, isFalse);
      expect(schoolsCtrl.schools.isNotEmpty, isTrue);

      final targetSchool = schoolsCtrl.schools.first;
      final initialFavoriteState = targetSchool.isFavorite;

      // Toggle favorite
      await schoolsCtrl.toggleFavorite(targetSchool.school.id);

      // Verify that isLoading was NOT set back to true (no screen reload / skeleton flash)
      expect(schoolsCtrl.isLoading.value, isFalse);

      // Verify in-place update
      final updatedSchool = schoolsCtrl.schools.firstWhere((s) => s.school.id == targetSchool.school.id);
      expect(updatedSchool.isFavorite, equals(!initialFavoriteState));

      // Verify sync with FavoritesController
      final isInFavorites = favCtrl.favoriteSchools.any((s) => s.school.id == targetSchool.school.id);
      expect(isInFavorites, equals(!initialFavoriteState));
    });

    test('FavoritesController.removeFavorite synchronizes back to SchoolsController', () async {
      final schoolsRepo = SchoolsRepositoryImpl();
      final contestRepo = ContestRepositoryImpl();

      Get.put<NavigationController>(NavigationController());
      final favCtrl = Get.put<FavoritesController>(
        FavoritesController(schoolsRepository: schoolsRepo, contestRepository: contestRepo),
      );
      final schoolsCtrl = Get.put<SchoolsController>(
        SchoolsController(repository: schoolsRepo),
      );

      await Future.delayed(const Duration(milliseconds: 50));

      // Ensure target school is favorited
      final targetSchool = schoolsCtrl.schools.first;
      if (!targetSchool.isFavorite) {
        await schoolsCtrl.toggleFavorite(targetSchool.school.id);
      }
      expect(schoolsCtrl.schools.firstWhere((s) => s.school.id == targetSchool.school.id).isFavorite, isTrue);

      // Remove favorite from FavoritesController
      await favCtrl.removeFavorite(targetSchool.school.id);

      // Verify removed from FavoritesController
      expect(favCtrl.favoriteSchools.any((s) => s.school.id == targetSchool.school.id), isFalse);

      // Verify in-place update in SchoolsController
      expect(schoolsCtrl.schools.firstWhere((s) => s.school.id == targetSchool.school.id).isFavorite, isFalse);
    });
  });
}
