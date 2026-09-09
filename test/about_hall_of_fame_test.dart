import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nsmq_flashscore/app/routes/app_pages.dart';
import 'package:nsmq_flashscore/app/routes/app_routes.dart';
import 'package:nsmq_flashscore/features/tournament/presentation/views/about_hall_of_fame_view.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildTestableWidget() {
    return GetMaterialApp(
      initialRoute: AppRoutes.aboutNsmq,
      getPages: AppPages.routes,
    );
  }

  group('AboutHallOfFameView Tests', () {
    testWidgets('Renders Hall of Fame tab by default with stats and top 3 podium', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('NSMQ ARCHIVE'), findsOneWidget);
      expect(find.text('HALL OF FAME & CHAMPIONS'), findsOneWidget);

      // Verify Tab buttons
      expect(find.text('HALL OF FAME'), findsOneWidget);
      expect(find.text('ABOUT NSMQ'), findsOneWidget);

      // Verify Quick Stat Highlights
      expect(find.text('31'), findsOneWidget);
      expect(find.text('TOURNAMENTS'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);
      expect(find.text('CHAMPIONS'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      expect(find.text('RECORD TITLES'), findsOneWidget);

      // Verify Top 3 Podium
      expect(find.text('THE TOP 3 POWERHOUSES'), findsOneWidget);
      expect(find.text('PRESEC Legon'), findsOneWidget);
      expect(find.text('Prempeh College'), findsOneWidget);
      expect(find.text('Mfantsipim School'), findsOneWidget);

      // Verify Honour Roll heading
      expect(find.text('HONOUR ROLL (RANKS 4 - 11)'), findsOneWidget);
    });

    testWidgets('Switches to Chronological Timeline sub-tab in Hall of Fame', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Tap "CHRONOLOGICAL TIMELINE" sub-tab
      final timelineTab = find.text('CHRONOLOGICAL TIMELINE');
      expect(timelineTab, findsOneWidget);
      await tester.tap(timelineTab);
      await tester.pumpAndSettle();

      // Verify Timeline header and items
      expect(find.text('CHAMPIONS BY YEAR (1994 - 2025)'), findsOneWidget);
      expect(find.text('2025'), findsOneWidget);
      expect(find.text('2024'), findsOneWidget);
      expect(find.text('2023'), findsOneWidget);
    });

    testWidgets('Switches to About NSMQ tab and renders 5 rounds and Quiz Mistresses', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Tap "ABOUT NSMQ" tab
      final aboutTab = find.text('ABOUT NSMQ');
      expect(aboutTab, findsOneWidget);
      await tester.tap(aboutTab);
      await tester.pumpAndSettle();

      // Verify Subtitle update
      expect(find.text('HISTORY, RULES & MISTRESSES'), findsOneWidget);

      // Verify Hero content
      expect(find.text('NATIONAL SCIENCE & MATHS QUIZ'), findsOneWidget);
      expect(find.text('Promoting STEM Excellence Since 1993'), findsOneWidget);

      // Verify 5 rounds section
      await tester.dragUntilVisible(
        find.text('Fundamental Concepts'),
        find.byType(ListView),
        const Offset(0, -60),
      );
      expect(find.text('Fundamental Concepts'), findsOneWidget);

      // Verify Quiz Mistresses section
      await tester.dragUntilVisible(
        find.text('Prof. Elsie Effah Kaufmann'),
        find.byType(ListView),
        const Offset(0, -60),
      );
      expect(find.text('Prof. Elsie Effah Kaufmann'), findsOneWidget);

      // Verify Partners & Primetime footer
      await tester.dragUntilVisible(
        find.text('PRIMETIME LIMITED • GHANA EDUCATION SERVICE'),
        find.byType(ListView),
        const Offset(0, -60),
      );
      expect(find.text('PRIMETIME LIMITED • GHANA EDUCATION SERVICE'), findsOneWidget);
    });

    testWidgets('Verify zero layout overflows on small screen 320x568', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Verify Hall of Fame tab on 320px
      expect(find.text('HALL OF FAME'), findsOneWidget);
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Switch to Timeline
      await tester.tap(find.text('CHRONOLOGICAL TIMELINE'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Switch to About NSMQ tab
      await tester.tap(find.text('ABOUT NSMQ'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
    });

    testWidgets('Tapping a champion navigates to SchoolDetailView', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Tap on PRESEC Legon
      await tester.tap(find.text('PRESEC Legon'));
      await tester.pumpAndSettle();

      // Should navigate to SchoolDetailView
      expect(find.text('SCHOOL PROFILE'), findsOneWidget);
    });
  });
}

