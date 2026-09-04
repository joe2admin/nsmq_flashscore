import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nsmq_flashscore/app/routes/app_pages.dart';
import 'package:nsmq_flashscore/app/routes/app_routes.dart';
import 'package:nsmq_flashscore/core/services/live_audio_service.dart';
import 'package:nsmq_flashscore/features/contest_detail/domain/entities/contest_detail.dart';
import 'package:nsmq_flashscore/features/contest_detail/domain/repositories/i_contest_detail_repository.dart';
import 'package:nsmq_flashscore/features/contest_detail/presentation/controllers/contest_detail_controller.dart';
import 'package:nsmq_flashscore/features/contest_detail/presentation/views/contest_detail_view.dart';
import 'package:nsmq_flashscore/features/contest_detail/presentation/widgets/contest_header_card.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/round_scores.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/school.dart';

class MockContestDetailRepo implements IContestDetailRepository {
  final Contest targetContest;

  MockContestDetailRepo(this.targetContest);

  @override
  Future<ContestDetail> getContestDetail(String contestId) async {
    return ContestDetail(
      contest: targetContest,
      quizMistress: 'Prof. Elsie Effah Kaufmann',
      venue: 'Saarah-Mensah Auditorium, KNUST',
      lineups: const [],
      headToHead: const [],
    );
  }
}

class FakeLiveAudioService implements ILiveAudioService {
  @override
  final RxBool isPlaying = false.obs;
  @override
  final RxBool isBuffering = false.obs;
  @override
  final RxBool isMuted = false.obs;
  @override
  final RxDouble volume = 1.0.obs;
  @override
  final Rx<String?> errorMessage = Rx<String?>(null);
  @override
  final RxString currentStreamUrl = ''.obs;

  @override
  Future<void> play(String url) async {}
  @override
  Future<void> pause() async {}
  @override
  Future<void> stop() async {}
  @override
  Future<void> togglePlay(String url) async {}
  @override
  Future<void> toggleMute() async {}
  @override
  Future<void> setVolume(double vol) async {}
  @override
  void dispose() {}
}

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  const schoolA = School(
    id: 'sch_presec',
    name: 'Presbyterian Boys\' Secondary School',
    shortName: 'PRESEC',
    region: 'Greater Accra',
  );

  const schoolB = School(
    id: 'sch_prempeh',
    name: 'Prempeh College',
    shortName: 'PREMPEH',
    region: 'Ashanti',
  );

  const schoolC = School(
    id: 'sch_mfantsipim',
    name: 'Mfantsipim School',
    shortName: 'MFANTSIPIM',
    region: 'Central',
  );

  group('Contest Domain Logic for Leaders and Highest Score', () {
    test('highestScore, leaders, and isSchoolLeader identify sole leader', () {
      final contest = Contest(
        id: 'c1',
        title: 'Contest 1',
        stage: 'Semi-Finals',
        scheduledAt: DateTime.now(),
        status: ContestStatus.live,
        entries: const [
          ContestantEntry(school: schoolA, scores: RoundScores(r1: 15)), // total 15
          ContestantEntry(school: schoolB, scores: RoundScores(r1: 20)), // total 20
          ContestantEntry(school: schoolC, scores: RoundScores(r1: 10)), // total 10
        ],
      );

      expect(contest.highestScore, equals(20));
      expect(contest.leaders.length, equals(1));
      expect(contest.leaders.first.school.id, equals('sch_prempeh'));
      expect(contest.isSchoolLeader('sch_prempeh'), isTrue);
      expect(contest.isSchoolLeader('sch_presec'), isFalse);
    });

    test('highestScore, leaders, and isSchoolLeader identify tied leaders', () {
      final tiedContest = Contest(
        id: 'c_tied',
        title: 'Contest Tied',
        stage: 'Semi-Finals',
        scheduledAt: DateTime.now(),
        status: ContestStatus.live,
        entries: const [
          ContestantEntry(school: schoolA, scores: RoundScores(r1: 25)), // total 25
          ContestantEntry(school: schoolB, scores: RoundScores(r1: 25)), // total 25
          ContestantEntry(school: schoolC, scores: RoundScores(r1: 18)), // total 18
        ],
      );

      expect(tiedContest.highestScore, equals(25));
      expect(tiedContest.leaders.length, equals(2));
      expect(tiedContest.isSchoolLeader('sch_presec'), isTrue);
      expect(tiedContest.isSchoolLeader('sch_prempeh'), isTrue);
      expect(tiedContest.isSchoolLeader('sch_mfantsipim'), isFalse);
    });
  });

  group('Contest Header Tags Display on Contest Detail Page', () {
    testWidgets('Live contest with single leader shows LEADING tag on highest scorer only', (tester) async {
      final liveContest = Contest(
        id: 'c_live_single',
        title: 'Contest 27',
        stage: 'Semi-Finals',
        scheduledAt: DateTime.now(),
        status: ContestStatus.live,
        entries: const [
          ContestantEntry(school: schoolA, scores: RoundScores(r1: 30)), // 30 (Leader)
          ContestantEntry(school: schoolB, scores: RoundScores(r1: 22)), // 22
          ContestantEntry(school: schoolC, scores: RoundScores(r1: 15)), // 15
        ],
      );

      final repo = MockContestDetailRepo(liveContest);
      Get.put<IContestDetailRepository>(repo);
      Get.put<ILiveAudioService>(FakeLiveAudioService());
      final controller = Get.put<ContestDetailController>(
        ContestDetailController(repository: repo, audioService: FakeLiveAudioService()),
      );
      await controller.loadContestDetail('c_live_single');

      await tester.pumpWidget(const GetMaterialApp(home: ContestDetailView()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(ContestHeaderCard), findsOneWidget);
      // Only 1 LEADING tag should be shown
      expect(find.text('LEADING'), findsOneWidget);
      expect(find.text('WINNER'), findsNothing);
    });

    testWidgets('Live contest with two tied leaders shows LEADING tag on BOTH schools', (tester) async {
      final tiedLiveContest = Contest(
        id: 'c_live_tied',
        title: 'Contest 28',
        stage: 'Semi-Finals',
        scheduledAt: DateTime.now(),
        status: ContestStatus.live,
        entries: const [
          ContestantEntry(school: schoolA, scores: RoundScores(r1: 35)), // 35 (Tied Leader)
          ContestantEntry(school: schoolB, scores: RoundScores(r1: 35)), // 35 (Tied Leader)
          ContestantEntry(school: schoolC, scores: RoundScores(r1: 20)), // 20
        ],
      );

      final repo = MockContestDetailRepo(tiedLiveContest);
      Get.put<IContestDetailRepository>(repo);
      Get.put<ILiveAudioService>(FakeLiveAudioService());
      final controller = Get.put<ContestDetailController>(
        ContestDetailController(repository: repo, audioService: FakeLiveAudioService()),
      );
      await controller.loadContestDetail('c_live_tied');

      await tester.pumpWidget(const GetMaterialApp(home: ContestDetailView()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Both tied schools must display LEADING tag!
      expect(find.text('LEADING'), findsNWidgets(2));
      expect(find.text('WINNER'), findsNothing);
    });

    testWidgets('Finished contest shows WINNER tag on highest point school', (tester) async {
      final finishedContest = Contest(
        id: 'c_finished',
        title: 'Contest 26',
        stage: 'Quarter-Finals',
        scheduledAt: DateTime.now().subtract(const Duration(hours: 4)),
        status: ContestStatus.finished,
        entries: const [
          ContestantEntry(school: schoolA, scores: RoundScores(r1: 20, r2: 15, r3: 10, r4: 10, r5: 6), isWinner: true), // 61
          ContestantEntry(school: schoolB, scores: RoundScores(r1: 18, r2: 9, r3: 7, r4: 8, r5: 3)), // 45
          ContestantEntry(school: schoolC, scores: RoundScores(r1: 12, r2: 6, r3: 4, r4: 6, r5: 0)), // 28
        ],
      );

      final repo = MockContestDetailRepo(finishedContest);
      Get.put<IContestDetailRepository>(repo);
      Get.put<ILiveAudioService>(FakeLiveAudioService());
      final controller = Get.put<ContestDetailController>(
        ContestDetailController(repository: repo, audioService: FakeLiveAudioService()),
      );
      await controller.loadContestDetail('c_finished');

      await tester.pumpWidget(const GetMaterialApp(home: ContestDetailView()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('WINNER'), findsOneWidget);
      expect(find.text('LEADING'), findsNothing);
    });

    testWidgets('Upcoming / scheduled contest shows NO tag for any school', (tester) async {
      final scheduledContest = Contest(
        id: 'c_scheduled',
        title: 'Contest 29',
        stage: 'Semi-Finals',
        scheduledAt: DateTime.now().add(const Duration(hours: 4)),
        status: ContestStatus.scheduled,
        entries: const [
          ContestantEntry(school: schoolA, scores: RoundScores()),
          ContestantEntry(school: schoolB, scores: RoundScores()),
          ContestantEntry(school: schoolC, scores: RoundScores()),
        ],
      );

      final repo = MockContestDetailRepo(scheduledContest);
      Get.put<IContestDetailRepository>(repo);
      Get.put<ILiveAudioService>(FakeLiveAudioService());
      final controller = Get.put<ContestDetailController>(
        ContestDetailController(repository: repo, audioService: FakeLiveAudioService()),
      );
      await controller.loadContestDetail('c_scheduled');

      await tester.pumpWidget(const GetMaterialApp(home: ContestDetailView()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // No tag should exist for upcoming contest!
      expect(find.text('LEADING'), findsNothing);
      expect(find.text('WINNER'), findsNothing);
      expect(find.text('LEAD'), findsNothing);
    });

    testWidgets('Three school boxes in ContestHeaderCard have identical width and height', (tester) async {
      final liveContest = Contest(
        id: 'c_live_sizes',
        title: 'Contest 27',
        stage: 'Semi-Finals',
        scheduledAt: DateTime.now(),
        status: ContestStatus.live,
        entries: const [
          ContestantEntry(school: schoolA, scores: RoundScores(r1: 30)),
          ContestantEntry(school: schoolB, scores: RoundScores(r1: 22)),
          ContestantEntry(school: schoolC, scores: RoundScores(r1: 15)),
        ],
      );

      final repo = MockContestDetailRepo(liveContest);
      Get.put<IContestDetailRepository>(repo);
      Get.put<ILiveAudioService>(FakeLiveAudioService());
      final controller = Get.put<ContestDetailController>(
        ContestDetailController(repository: repo, audioService: FakeLiveAudioService()),
      );
      await controller.loadContestDetail('c_live_sizes');

      await tester.pumpWidget(const GetMaterialApp(home: ContestDetailView()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final card0 = find.byKey(const Key('contest_school_card_0'));
      final card1 = find.byKey(const Key('contest_school_card_1'));
      final card2 = find.byKey(const Key('contest_school_card_2'));

      expect(card0, findsOneWidget);
      expect(card1, findsOneWidget);
      expect(card2, findsOneWidget);

      final size0 = tester.getSize(card0);
      final size1 = tester.getSize(card1);
      final size2 = tester.getSize(card2);

      expect(size0.width, equals(size1.width));
      expect(size1.width, equals(size2.width));
      expect(size0.height, equals(size1.height));
      expect(size1.height, equals(size2.height));
    });

    testWidgets('Pressing any of the 3 schools navigates to the schools page', (tester) async {
      final liveContest = Contest(
        id: 'c_live_tap',
        title: 'Contest 27',
        stage: 'Semi-Finals',
        scheduledAt: DateTime.now(),
        status: ContestStatus.live,
        entries: const [
          ContestantEntry(school: schoolA, scores: RoundScores(r1: 30)),
          ContestantEntry(school: schoolB, scores: RoundScores(r1: 22)),
          ContestantEntry(school: schoolC, scores: RoundScores(r1: 15)),
        ],
      );

      final repo = MockContestDetailRepo(liveContest);
      Get.put<IContestDetailRepository>(repo);
      Get.put<ILiveAudioService>(FakeLiveAudioService());
      final controller = Get.put<ContestDetailController>(
        ContestDetailController(repository: repo, audioService: FakeLiveAudioService()),
      );
      await controller.loadContestDetail('c_live_tap');

      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.contestDetail,
          getPages: AppPages.routes,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // 1. Verify school cards are present
      final card0 = find.byKey(const Key('contest_school_card_0'));
      expect(card0, findsOneWidget);

      // 2. Tap school card 0 (schoolA -> PRESEC)
      await tester.tap(card0);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // 3. Verify we navigated to schoolDetail for PRESEC
      expect(Get.currentRoute, equals(AppRoutes.schoolDetail));
      expect(find.text('SCHOOL PROFILE'), findsOneWidget);

      // 4. Go back to contest detail
      Get.back();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(Get.currentRoute, equals(AppRoutes.contestDetail));

      // 5. Tap school card 1 (schoolB -> PREMPEH)
      final card1 = find.byKey(const Key('contest_school_card_1'));
      await tester.tap(card1);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(Get.currentRoute, equals(AppRoutes.schoolDetail));
      expect(find.text('SCHOOL PROFILE'), findsOneWidget);

      // 6. Go back to contest detail
      Get.back();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // 7. Tap school card 2 (schoolC -> MFANTSIPIM)
      final card2 = find.byKey(const Key('contest_school_card_2'));
      await tester.tap(card2);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(Get.currentRoute, equals(AppRoutes.schoolDetail));
      expect(find.text('SCHOOL PROFILE'), findsOneWidget);
    });
  });
}
