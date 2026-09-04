import 'package:get/get.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/repositories/i_contest_repository.dart';
import 'package:nsmq_flashscore/features/schools/domain/repositories/i_schools_repository.dart';
import '../controllers/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesController>(
      () => FavoritesController(
        schoolsRepository: Get.find<ISchoolsRepository>(),
        contestRepository: Get.find<IContestRepository>(),
      ),
    );
  }
}
