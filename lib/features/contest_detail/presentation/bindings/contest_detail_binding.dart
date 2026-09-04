import 'package:get/get.dart';
import '../../../../core/services/live_audio_service.dart';
import '../../data/repositories/contest_detail_repository_impl.dart';
import '../../domain/repositories/i_contest_detail_repository.dart';
import '../controllers/contest_detail_controller.dart';

class ContestDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IContestDetailRepository>(() => ContestDetailRepositoryImpl());
    Get.lazyPut<ILiveAudioService>(() => LiveAudioServiceImpl());
    Get.lazyPut<ContestDetailController>(
      () => ContestDetailController(
        repository: Get.find<IContestDetailRepository>(),
        audioService: Get.find<ILiveAudioService>(),
      ),
    );
  }
}
