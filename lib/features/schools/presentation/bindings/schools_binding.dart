import 'package:get/get.dart';
import '../../data/repositories/schools_repository_impl.dart';
import '../../domain/repositories/i_schools_repository.dart';
import '../controllers/school_detail_controller.dart';
import '../controllers/schools_controller.dart';

class SchoolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ISchoolsRepository>(() => SchoolsRepositoryImpl(), fenix: true);
    Get.lazyPut<SchoolsController>(
      () => SchoolsController(repository: Get.find<ISchoolsRepository>()),
      fenix: true,
    );
    Get.lazyPut<SchoolDetailController>(
      () => SchoolDetailController(repository: Get.find<ISchoolsRepository>()),
      fenix: true,
    );
  }
}
