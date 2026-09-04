import 'package:get/get.dart';
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

  Future<void> toggleFavorite(String id) async {
    await repository.toggleFavorite(id);
    fetchSchools();
  }
}
