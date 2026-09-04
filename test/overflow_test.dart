import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nsmq_flashscore/app/routes/app_routes.dart';
import 'package:nsmq_flashscore/features/live_scores/data/providers/mock_contest_data.dart';
import 'package:nsmq_flashscore/features/shell/presentation/controllers/navigation_controller.dart';
import 'package:nsmq_flashscore/main.dart';

import 'package:nsmq_flashscore/features/tournament/presentation/controllers/tournament_controller.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  final viewports = [
    const Size(320, 568), // Small device (iPhone SE 1st gen / small Android)
    const Size(360, 640), // Standard Android compact
    const Size(375, 667), // iPhone SE / 8
    const Size(390, 844), // iPhone 13/14
    const Size(412, 915), // Pixel / Galaxy S
  ];

  for (final size in viewports) {
    testWidgets('Verify zero overflows across all 5 tabs and detail screens on ${size.width}x${size.height}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Launch full app with GetMaterialApp
      await tester.pumpWidget(const NsmqFlashscoreApp());
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      final navController = Get.find<NavigationController>();

      // 1. Tab 0: Contests
      expect(find.text('NSMQ FLASHSCORE'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));

      // 2. Tab 1: Bracket / Tournament
      navController.changePage(1);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      // Verify Grand Finale and Trophy stages also have zero overflows
      if (Get.isRegistered<TournamentController>()) {
        final tController = Get.find<TournamentController>();
        tController.selectStage(4, animate: false);
        await tester.pump(const Duration(milliseconds: 200));
        tController.selectStage(5, animate: false);
        await tester.pump(const Duration(milliseconds: 200));
      }

      // 3. Tab 2: Schools Directory
      navController.changePage(2);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      // 4. Tab 3: News / Feed
      navController.changePage(3);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      // 5. Tab 4: Favorites
      navController.changePage(4);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      // Return to Tab 0: Contests
      navController.changePage(0);
      await tester.pump(const Duration(milliseconds: 300));

      // 6. Navigate to Contest Detail screen
      Get.toNamed(AppRoutes.contestDetail, arguments: MockContestData.getContests().first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));

      Get.back();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // 7. Navigate to School Detail screen
      Get.toNamed(AppRoutes.schoolDetail, arguments: 'sch_presec');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));

      Get.back();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    });
  }
}
