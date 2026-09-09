import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../features/contest_detail/data/repositories/contest_detail_repository_impl.dart';
import '../../features/contest_detail/domain/repositories/i_contest_detail_repository.dart';
import '../../features/favorites/presentation/controllers/favorites_controller.dart';
import '../../features/live_scores/data/repositories/contest_repository_impl.dart';
import '../../features/live_scores/domain/repositories/i_contest_repository.dart';
import '../../features/live_scores/presentation/controllers/live_scores_controller.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/domain/repositories/i_news_repository.dart';
import '../../features/news/presentation/controllers/news_controller.dart';
import '../../features/schools/data/repositories/schools_repository_impl.dart';
import '../../features/schools/domain/repositories/i_schools_repository.dart';
import '../../features/schools/presentation/controllers/schools_controller.dart';
import '../../features/shell/presentation/controllers/navigation_controller.dart';
import '../../features/tournament/data/repositories/tournament_repository_impl.dart';
import '../../features/tournament/domain/repositories/i_tournament_repository.dart';
import '../../features/tournament/presentation/controllers/tournament_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 0. Network & Core Services
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // 1. Repositories (Singletons / Lazy)
    Get.lazyPut<IContestRepository>(() => ContestRepositoryImpl(), fenix: true);
    Get.lazyPut<ITournamentRepository>(() => TournamentRepositoryImpl(), fenix: true);
    Get.lazyPut<ISchoolsRepository>(() => SchoolsRepositoryImpl(), fenix: true);
    Get.lazyPut<INewsRepository>(() => NewsRepositoryImpl(), fenix: true);
    Get.lazyPut<IContestDetailRepository>(() => ContestDetailRepositoryImpl(), fenix: true);

    // 2. Shell Navigation Controller
    Get.put<NavigationController>(NavigationController(), permanent: true);

    // 3. Tab Controllers (fenix: true ensures they are recreated on demand if evicted)
    Get.lazyPut<LiveScoresController>(
      () => LiveScoresController(repository: Get.find<IContestRepository>()),
      fenix: true,
    );
    Get.lazyPut<TournamentController>(
      () => TournamentController(repository: Get.find<ITournamentRepository>()),
      fenix: true,
    );
    Get.lazyPut<SchoolsController>(
      () => SchoolsController(repository: Get.find<ISchoolsRepository>()),
      fenix: true,
    );
    Get.lazyPut<NewsController>(
      () => NewsController(repository: Get.find<INewsRepository>()),
      fenix: true,
    );
    Get.lazyPut<FavoritesController>(
      () => FavoritesController(
        schoolsRepository: Get.find<ISchoolsRepository>(),
        contestRepository: Get.find<IContestRepository>(),
      ),
      fenix: true,
    );
  }
}
