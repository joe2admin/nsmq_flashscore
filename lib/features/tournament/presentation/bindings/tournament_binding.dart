import 'package:get/get.dart';
import '../../data/repositories/tournament_repository_impl.dart';
import '../../domain/repositories/i_tournament_repository.dart';
import '../controllers/tournament_controller.dart';

class TournamentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ITournamentRepository>(() => TournamentRepositoryImpl());
    Get.lazyPut<TournamentController>(
      () => TournamentController(repository: Get.find<ITournamentRepository>()),
    );
  }
}
