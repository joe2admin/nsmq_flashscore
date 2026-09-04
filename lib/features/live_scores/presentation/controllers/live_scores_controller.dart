import 'package:get/get.dart';
import '../../domain/entities/contest.dart';
import '../../domain/repositories/i_contest_repository.dart';

class LiveScoresController extends GetxController {
  final IContestRepository repository;

  LiveScoresController({required this.repository});

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<ContestStatus?> selectedStatus = Rx<ContestStatus?>(null);
  final RxString selectedStage = 'All Stages'.obs;
  final RxString searchQuery = ''.obs;

  final RxList<Contest> contests = <Contest>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContests();
  }

  Future<void> fetchContests() async {
    isLoading.value = true;
    try {
      final results = await repository.getContests(
        date: selectedDate.value,
        status: selectedStatus.value,
        stage: selectedStage.value,
        searchQuery: searchQuery.value,
      );
      contests.assignAll(results);
    } finally {
      isLoading.value = false;
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    fetchContests();
  }

  void selectStatus(ContestStatus? status) {
    selectedStatus.value = status;
    fetchContests();
  }

  void selectStage(String stage) {
    selectedStage.value = stage;
    fetchContests();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    fetchContests();
  }

  int get liveCount => contests.where((c) => c.status == ContestStatus.live).length;
}
