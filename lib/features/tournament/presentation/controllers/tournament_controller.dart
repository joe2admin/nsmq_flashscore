import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/tournament_stage.dart';
import '../../domain/repositories/i_tournament_repository.dart';

class TournamentController extends GetxController {
  final ITournamentRepository repository;

  TournamentController({required this.repository});

  final RxList<TournamentStage> stages = <TournamentStage>[].obs;
  final RxList<TournamentAward> awards = <TournamentAward>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt selectedStageIndex = 0.obs;

  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedStageIndex.value);
    loadTournamentData();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> loadTournamentData() async {
    isLoading.value = true;
    try {
      final fetchedStages = await repository.getStages();
      final fetchedAwards = await repository.getAwards();
      stages.assignAll(fetchedStages);
      awards.assignAll(fetchedAwards);

      // Default to the current stage if available
      final currentIdx = fetchedStages.indexWhere((s) => s.isCurrent);
      if (currentIdx != -1) {
        selectedStageIndex.value = currentIdx;
        if (pageController.hasClients) {
          pageController.jumpToPage(currentIdx);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Total pages including tournament contest stages and the Championship Trophy page.
  int get totalPages => stages.isEmpty ? 0 : stages.length + 1;

  void selectStage(int index, {bool animate = true}) {
    if (index < 0 || index >= totalPages) return;
    selectedStageIndex.value = index;
    if (pageController.hasClients) {
      if (animate) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        pageController.jumpToPage(index);
      }
    }
  }

  void onPageChanged(int index) {
    selectedStageIndex.value = index;
  }
}
