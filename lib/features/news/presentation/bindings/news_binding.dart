import 'package:get/get.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/i_news_repository.dart';
import '../controllers/news_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<INewsRepository>(() => NewsRepositoryImpl());
    Get.lazyPut<NewsController>(
      () => NewsController(repository: Get.find<INewsRepository>()),
    );
  }
}
