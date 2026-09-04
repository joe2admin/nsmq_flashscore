import 'package:get/get.dart';
import '../../../../core/constants/nsmq_constants.dart';
import '../../../../core/services/live_audio_service.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';
import 'package:nsmq_flashscore/features/contest_detail/domain/entities/contest_detail.dart';
import 'package:nsmq_flashscore/features/contest_detail/domain/repositories/i_contest_detail_repository.dart';

class ContestDetailController extends GetxController {
  final IContestDetailRepository repository;
  final ILiveAudioService audioService;

  ContestDetailController({
    required this.repository,
    ILiveAudioService? audioService,
  }) : audioService = audioService ?? LiveAudioServiceImpl();

  final Rx<ContestDetail?> contestDetail = Rx<ContestDetail?>(null);
  final RxBool isLoading = true.obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxBool isAudioExpanded = true.obs;

  bool get isLiveMatch => contestDetail.value?.contest.status == ContestStatus.live;

  String get liveAudioUrl {
    final contestAudio = contestDetail.value?.contest.liveAudioUrl;
    if (contestAudio != null && contestAudio.isNotEmpty) {
      return contestAudio;
    }
    return NsmqConstants.defaultLiveAudioStream;
  }

  RxBool get isAudioPlaying => audioService.isPlaying;
  RxBool get isAudioBuffering => audioService.isBuffering;
  RxBool get isAudioMuted => audioService.isMuted;
  RxDouble get audioVolume => audioService.volume;
  Rx<String?> get audioError => audioService.errorMessage;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    String contestId = 'contest_live_101';
    if (args is Contest) {
      contestId = args.id;
    } else if (args is String) {
      contestId = args;
    }
    loadContestDetail(contestId);
  }

  Future<void> loadContestDetail(String contestId) async {
    isLoading.value = true;
    try {
      final detail = await repository.getContestDetail(contestId);
      contestDetail.value = detail;
    } finally {
      isLoading.value = false;
    }
  }

  void setTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> toggleAudioPlayback() async {
    await audioService.togglePlay(liveAudioUrl);
  }

  Future<void> toggleAudioMute() async {
    await audioService.toggleMute();
  }

  Future<void> setAudioVolume(double vol) async {
    await audioService.setVolume(vol);
  }

  void toggleAudioExpanded() {
    isAudioExpanded.toggle();
  }

  @override
  void onClose() {
    audioService.stop();
    audioService.dispose();
    super.onClose();
  }
}
