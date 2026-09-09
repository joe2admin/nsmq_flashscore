import 'dart:async';
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

  Timer? _livePollingTimer;

  @override
  void onInit() {
    super.onInit();
    fetchContests();
  }

  @override
  void onClose() {
    _stopPolling();
    super.onClose();
  }

  Future<void> fetchContests({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    try {
      final results = await repository.getContests(
        date: selectedDate.value,
        status: selectedStatus.value,
        stage: selectedStage.value,
        searchQuery: searchQuery.value,
      );
      contests.assignAll(results);
      _checkPolling();
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  Future<void> refreshContests() async {
    await fetchContests(showLoading: false);
  }

  void _checkPolling() {
    if (liveCount > 0) {
      if (_livePollingTimer == null || !_livePollingTimer!.isActive) {
        _livePollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
          fetchContests(showLoading: false);
        });
      }
    } else {
      _stopPolling();
    }
  }

  void _stopPolling() {
    _livePollingTimer?.cancel();
    _livePollingTimer = null;
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
