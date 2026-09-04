import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nsmq_flashscore/core/constants/nsmq_constants.dart';
import 'package:nsmq_flashscore/core/services/live_audio_service.dart';
import 'package:nsmq_flashscore/features/contest_detail/domain/entities/contest_detail.dart';
import 'package:nsmq_flashscore/features/contest_detail/domain/repositories/i_contest_detail_repository.dart';
import 'package:nsmq_flashscore/features/contest_detail/presentation/controllers/contest_detail_controller.dart';
import 'package:nsmq_flashscore/features/contest_detail/presentation/views/contest_detail_view.dart';
import 'package:nsmq_flashscore/features/contest_detail/presentation/widgets/contest_live_audio_card.dart';
import 'package:nsmq_flashscore/features/live_scores/data/models/contest_model.dart';
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

  bool wasDisposed = false;

  @override
  Future<void> play(String url) async {
    currentStreamUrl.value = url;
    isPlaying.value = true;
    isBuffering.value = false;
  }

  @override
  Future<void> pause() async {
    isPlaying.value = false;
    isBuffering.value = false;
  }

  @override
  Future<void> stop() async {
    isPlaying.value = false;
    isBuffering.value = false;
  }

  @override
  Future<void> togglePlay(String url) async {
    if (isPlaying.value) {
      await pause();
    } else {
      await play(url);
    }
  }

  @override
  Future<void> setVolume(double vol) async {
    final clamped = vol.clamp(0.0, 1.0);
    volume.value = clamped;
    isMuted.value = clamped == 0.0;
  }

  @override
  Future<void> toggleMute() async {
    if (isMuted.value) {
      await setVolume(1.0);
    } else {
      await setVolume(0.0);
    }
  }

  @override
  void dispose() {
    wasDisposed = true;
    isPlaying.value = false;
  }
}

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  const sampleSchool = School(
    id: 'sch_presec',
    name: 'Presbyterian Boys\' Secondary School',
    shortName: 'PRESEC LEGON',
    region: 'Greater Accra',
  );

  final liveContest = Contest(
    id: 'test_live_1',
    title: 'Contest 14',
    stage: 'Semi-Finals',
    scheduledAt: DateTime.now(),
    status: ContestStatus.live,
    currentRound: 3,
    currentRoundName: 'Round 3: Problem of the Day',
    liveAudioUrl: 'https://stream.zeno.fm/t3q5zg84n7zuv',
    entries: const [
      ContestantEntry(
        school: sampleSchool,
        scores: RoundScores(r1: 15, r2: 10, r3: 10),
      ),
    ],
  );

  final finishedContest = Contest(
    id: 'test_fin_1',
    title: 'Contest 12',
    stage: 'Quarter-Finals',
    scheduledAt: DateTime.now().subtract(const Duration(hours: 3)),
    status: ContestStatus.finished,
    currentRound: 5,
    currentRoundName: 'Contest Concluded',
    entries: const [
      ContestantEntry(
        school: sampleSchool,
        scores: RoundScores(r1: 20, r2: 15, r3: 10, r4: 10, r5: 5),
        isWinner: true,
      ),
    ],
  );

  final scheduledContest = Contest(
    id: 'test_sched_1',
    title: 'Contest 15',
    stage: 'Semi-Finals',
    scheduledAt: DateTime.now().add(const Duration(hours: 3)),
    status: ContestStatus.scheduled,
    currentRound: 0,
    currentRoundName: 'Scheduled',
    entries: const [
      ContestantEntry(
        school: sampleSchool,
        scores: RoundScores(),
      ),
    ],
  );

  group('Live Audio Model & Serialization', () {
    test('Contest entity stores liveAudioUrl correctly', () {
      expect(liveContest.liveAudioUrl, equals('https://stream.zeno.fm/t3q5zg84n7zuv'));
      expect(finishedContest.liveAudioUrl, isNull);
    });

    test('ContestModel serializes and deserializes live_audio_url', () {
      final model = ContestModel(
        id: 'c1',
        title: 'Contest 1',
        stage: 'Quarter-Finals',
        scheduledAt: DateTime.now(),
        status: ContestStatus.live,
        currentRound: 2,
        currentRoundName: 'Round 2',
        liveAudioUrl: 'https://example.com/audio.mp3',
        entries: const [],
      );

      final json = model.toJson();
      expect(json['live_audio_url'], equals('https://example.com/audio.mp3'));

      final parsed = ContestModel.fromJson(json);
      expect(parsed.liveAudioUrl, equals('https://example.com/audio.mp3'));
      expect(parsed.status, equals(ContestStatus.live));
    });
  });

  group('Live Audio Service & Controller Logic', () {
    test('FakeLiveAudioService plays, pauses, toggles mute, and clamps volume', () async {
      final audioService = FakeLiveAudioService();

      expect(audioService.isPlaying.value, isFalse);
      await audioService.play('https://audio.stream/live');
      expect(audioService.isPlaying.value, isTrue);
      expect(audioService.currentStreamUrl.value, equals('https://audio.stream/live'));

      await audioService.togglePlay('https://audio.stream/live');
      expect(audioService.isPlaying.value, isFalse);

      await audioService.setVolume(0.5);
      expect(audioService.volume.value, equals(0.5));
      expect(audioService.isMuted.value, isFalse);

      await audioService.toggleMute();
      expect(audioService.isMuted.value, isTrue);
      expect(audioService.volume.value, equals(0.0));

      await audioService.toggleMute();
      expect(audioService.isMuted.value, isFalse);
      expect(audioService.volume.value, equals(1.0));

      audioService.dispose();
      expect(audioService.wasDisposed, isTrue);
    });

    test('ContestDetailController uses contest audio URL and manages audio state', () async {
      final audioService = FakeLiveAudioService();
      final controller = ContestDetailController(
        repository: MockContestDetailRepo(liveContest),
        audioService: audioService,
      );

      await controller.loadContestDetail('test_live_1');
      expect(controller.isLiveMatch, isTrue);
      expect(controller.liveAudioUrl, equals('https://stream.zeno.fm/t3q5zg84n7zuv'));

      await controller.toggleAudioPlayback();
      expect(audioService.isPlaying.value, isTrue);

      controller.toggleAudioExpanded();
      expect(controller.isAudioExpanded.value, isFalse);
      controller.toggleAudioExpanded();
      expect(controller.isAudioExpanded.value, isTrue);

      controller.onClose();
      expect(audioService.wasDisposed, isTrue);
    });

    test('ContestDetailController falls back to default live stream if not set', () async {
      final audioService = FakeLiveAudioService();
      final liveContestNoUrl = Contest(
        id: 'test_live_no_url',
        title: 'Contest Live',
        stage: 'Semi-Finals',
        scheduledAt: DateTime.now(),
        status: ContestStatus.live,
        entries: const [],
      );

      final controller = ContestDetailController(
        repository: MockContestDetailRepo(liveContestNoUrl),
        audioService: audioService,
      );

      await controller.loadContestDetail('test_live_no_url');
      expect(controller.liveAudioUrl, equals(NsmqConstants.defaultLiveAudioStream));
    });
  });

  group('Live Audio Widget Visibility (Only for Live Matches)', () {
    testWidgets('ContestLiveAudioCard renders on ContestDetailView for LIVE contest', (tester) async {
      final fakeAudio = FakeLiveAudioService();
      final repo = MockContestDetailRepo(liveContest);

      Get.put<IContestDetailRepository>(repo);
      Get.put<ILiveAudioService>(fakeAudio);
      final controller = Get.put<ContestDetailController>(
        ContestDetailController(repository: repo, audioService: fakeAudio),
      );

      await controller.loadContestDetail('test_live_1');

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ContestDetailView(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify Live Audio Card is present
      expect(find.byType(ContestLiveAudioCard), findsOneWidget);
      expect(find.text('NSMQ LIVE AUDIO • RADIO FEED'), findsOneWidget);
      expect(find.text('LIVE FEED'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);

      // Tap Play button
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(fakeAudio.isPlaying.value, isTrue);
      expect(find.text('ON AIR'), findsOneWidget);
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);

      // Tap Mute button
      await tester.tap(find.byIcon(Icons.volume_up));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(fakeAudio.isMuted.value, isTrue);
      expect(find.byIcon(Icons.volume_off), findsOneWidget);

      // Collapse and Expand
      await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Broadcasting live audio...'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    });

    testWidgets('ContestLiveAudioCard does NOT render on ContestDetailView for FINISHED contest', (tester) async {
      final fakeAudio = FakeLiveAudioService();
      final repo = MockContestDetailRepo(finishedContest);

      Get.put<IContestDetailRepository>(repo);
      Get.put<ILiveAudioService>(fakeAudio);
      final controller = Get.put<ContestDetailController>(
        ContestDetailController(repository: repo, audioService: fakeAudio),
      );

      await controller.loadContestDetail('test_fin_1');

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ContestDetailView(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify Live Audio Card is NOT present
      expect(find.byType(ContestLiveAudioCard), findsNothing);
      expect(find.text('NSMQ LIVE AUDIO • RADIO FEED'), findsNothing);
    });

    testWidgets('ContestLiveAudioCard does NOT render on ContestDetailView for SCHEDULED contest', (tester) async {
      final fakeAudio = FakeLiveAudioService();
      final repo = MockContestDetailRepo(scheduledContest);

      Get.put<IContestDetailRepository>(repo);
      Get.put<ILiveAudioService>(fakeAudio);
      final controller = Get.put<ContestDetailController>(
        ContestDetailController(repository: repo, audioService: fakeAudio),
      );

      await controller.loadContestDetail('test_sched_1');

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ContestDetailView(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify Live Audio Card is NOT present
      expect(find.byType(ContestLiveAudioCard), findsNothing);
      expect(find.text('NSMQ LIVE AUDIO • RADIO FEED'), findsNothing);
    });
  });
}
