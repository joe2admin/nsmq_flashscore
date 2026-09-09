import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../views/about_hall_of_fame_view.dart';

/// Legacy entry point maintaining full backwards compatibility.
/// Routes callers to the redesigned AboutHallOfFameView.
class NsmqHistorySheet extends StatelessWidget {
  const NsmqHistorySheet({super.key});

  static void show(BuildContext context) {
    Get.toNamed(AppRoutes.aboutNsmq);
  }

  @override
  Widget build(BuildContext context) {
    return const AboutHallOfFameView();
  }
}

