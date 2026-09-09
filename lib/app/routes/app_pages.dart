import 'package:get/get.dart';
import '../../features/contest_detail/presentation/bindings/contest_detail_binding.dart';
import '../../features/contest_detail/presentation/views/contest_detail_view.dart';
import '../../features/schools/presentation/bindings/schools_binding.dart';
import '../../features/schools/presentation/views/school_detail_view.dart';
import '../../features/shell/presentation/views/main_shell_view.dart';
import '../../features/tournament/presentation/views/about_hall_of_fame_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.shell;

  static final routes = [
    GetPage(
      name: AppRoutes.shell,
      page: () => const MainShellView(),
    ),
    GetPage(
      name: AppRoutes.contestDetail,
      page: () => const ContestDetailView(),
      binding: ContestDetailBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: AppRoutes.schoolDetail,
      page: () => const SchoolDetailView(),
      binding: SchoolsBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: AppRoutes.aboutNsmq,
      page: () => const AboutHallOfFameView(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 200),
    ),
  ];
}
