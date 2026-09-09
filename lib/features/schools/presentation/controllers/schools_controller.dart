import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../favorites/presentation/controllers/favorites_controller.dart';
import '../../../shell/presentation/controllers/navigation_controller.dart';
import '../../domain/entities/school_profile.dart';
import '../../domain/repositories/i_schools_repository.dart';

class SchoolsController extends GetxController {
  final ISchoolsRepository repository;

  SchoolsController({required this.repository});

  final RxList<SchoolProfile> schools = <SchoolProfile>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedRegion = 'All Regions'.obs;
  final RxBool onlyChampions = false.obs;
  final RxString searchQuery = ''.obs;

  final List<String> regions = const [
    'All Regions',
    'Greater Accra',
    'Ashanti',
    'Central',
    'Eastern',
    'Volta',
    'Northern',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchSchools();
  }

  Future<void> fetchSchools() async {
    isLoading.value = true;
    try {
      final list = await repository.getSchools(
        searchQuery: searchQuery.value,
        region: selectedRegion.value,
        onlyChampions: onlyChampions.value,
      );
      schools.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  void selectRegion(String region) {
    selectedRegion.value = region;
    fetchSchools();
  }

  void toggleOnlyChampions() {
    onlyChampions.value = !onlyChampions.value;
    fetchSchools();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    fetchSchools();
  }

  /// Update favorite state in-place from external controllers without reloading
  void updateSchoolFavorite(String id, bool isFavorite) {
    final index = schools.indexWhere((s) => s.school.id == id);
    if (index != -1 && schools[index].isFavorite != isFavorite) {
      schools[index] = schools[index].copyWith(isFavorite: isFavorite);
      schools.refresh();
    }
  }

  Future<void> toggleFavorite(String id) async {
    final index = schools.indexWhere((s) => s.school.id == id);
    if (index == -1) return;

    final current = schools[index];
    final updated = current.copyWith(isFavorite: !current.isFavorite);
    schools[index] = updated;
    schools.refresh();

    // Immediately sync with FavoritesController
    if (Get.isRegistered<FavoritesController>()) {
      Get.find<FavoritesController>().onSchoolFavoriteToggled(updated);
    }

    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    final schoolDisplayName = updated.school.shortName.isNotEmpty
        ? updated.school.shortName
        : updated.school.name;

    if (updated.isFavorite) {
      Get.snackbar(
        'Pinned to Favorites',
        '$schoolDisplayName added to your favorites.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: NeoColors.surface,
        colorText: NeoColors.textPrimary,
        borderColor: NeoColors.border,
        borderWidth: 2,
        margin: const EdgeInsets.all(12),
        mainButton: TextButton(
          onPressed: () {
            if (Get.isSnackbarOpen) {
              Get.closeCurrentSnackbar();
            }
            if (Get.isRegistered<NavigationController>()) {
              Get.find<NavigationController>().changePage(4);
            }
          },
          child: const Text(
            'VIEW',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: NeoColors.nsmqRed,
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
      );
    }

    // Persist to repository in background without blocking or reloading the list
    try {
      await repository.toggleFavorite(id);
    } catch (e) {
      // Revert if error occurs
      final revertIndex = schools.indexWhere((s) => s.school.id == id);
      if (revertIndex != -1) {
        schools[revertIndex] = current;
        schools.refresh();
      }
      if (Get.isRegistered<FavoritesController>()) {
        Get.find<FavoritesController>().onSchoolFavoriteToggled(current);
      }
    }
  }
}

