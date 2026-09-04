import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nsmq_flashscore/app/theme/app_colors.dart';
import 'package:nsmq_flashscore/features/tournament/domain/entities/tournament_stage.dart';
import 'package:nsmq_flashscore/features/tournament/domain/repositories/i_tournament_repository.dart';
import 'package:nsmq_flashscore/features/tournament/data/repositories/tournament_repository_impl.dart';
import 'package:nsmq_flashscore/features/tournament/presentation/controllers/tournament_controller.dart';
import 'package:nsmq_flashscore/features/tournament/presentation/views/tournament_view.dart';
import 'package:nsmq_flashscore/features/tournament/presentation/widgets/stage_bracket_card.dart';
import 'package:nsmq_flashscore/features/tournament/presentation/widgets/tournament_bracket_connectors.dart';
import 'package:nsmq_flashscore/features/tournament/presentation/widgets/trophy_champion_widget.dart';
import 'package:nsmq_flashscore/features/contest_detail/presentation/views/contest_detail_view.dart';
import 'package:nsmq_flashscore/features/contest_detail/presentation/controllers/contest_detail_controller.dart';
import 'package:nsmq_flashscore/features/contest_detail/data/repositories/contest_detail_repository_impl.dart';

class MockTournamentRepository implements ITournamentRepository {
  final List<TournamentStage> mockStages;
  final List<TournamentAward> mockAwards;

  MockTournamentRepository({required this.mockStages, required this.mockAwards});

  @override
  Future<List<TournamentStage>> getStages() async => mockStages;

  @override
  Future<List<TournamentAward>> getAwards() async => mockAwards;
}

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  group('Tournament Order & NSMQ Rules Data Tests', () {
    test('TournamentRepositoryImpl stages follow exact NSMQ tournament progression order', () async {
      final repo = TournamentRepositoryImpl();
      final stages = await repo.getStages();

      expect(stages.length, equals(5));

      // 1. Preliminary Round
      expect(stages[0].id, equals('stage_prelims'));
      expect(stages[0].name, equals('Preliminary Round'));
      expect(stages[0].subtitle, equals('3 PARTICIPANTS PER MATCH'));

      // 2. One-Eighth Stage
      expect(stages[1].id, equals('stage_one_eighth'));
      expect(stages[1].name, equals('One-Eighth Stage'));
      expect(stages[1].subtitle, equals('3 PARTICIPANTS PER MATCH'));

      // 3. Quarter Finals
      expect(stages[2].id, equals('stage_quarters'));
      expect(stages[2].name, equals('Quarter Finals'));
      expect(stages[2].subtitle, equals('3 PARTICIPANTS PER MATCH'));

      // 4. Semi Finals
      expect(stages[3].id, equals('stage_semis'));
      expect(stages[3].name, equals('Semi Finals'));
      expect(stages[3].subtitle, equals('3 PARTICIPANTS PER MATCH'));

      // 5. Grand Finale
      expect(stages[4].id, equals('stage_finale'));
      expect(stages[4].name, equals('Grand Finale'));
      expect(stages[4].subtitle, equals('3 PARTICIPANTS PER MATCH'));

      // Verify every contest has exactly 3 participants (NSMQ official format)
      for (final stage in stages) {
        for (final contest in stage.contests) {
          expect(contest.schoolNames.length, equals(3),
              reason: 'Contest ${contest.id} in ${stage.name} must have 3 participants');
          expect(contest.scores.length, equals(3));
          expect(contest.displayLabel.isNotEmpty, isTrue);
        }
      }
    });
  });

  group('Visual Tournament Bracket Widgets Tests', () {
    testWidgets('TrophyChampionWidget renders trophy canvas and NSMQ CHAMPION banner when champion exists', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrophyChampionWidget(
              championSchool: 'PRESEC LEGON',
              titles: '8-TIME CHAMPIONS',
            ),
          ),
        ),
      );

      expect(find.text('NSMQ CHAMPION'), findsOneWidget);
      expect(find.text('PRESEC LEGON'), findsOneWidget);
      expect(find.text('8-TIME CHAMPIONS'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('TrophyChampionWidget renders awaiting champion banner when champion is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrophyChampionWidget(
              championSchool: null,
            ),
          ),
        ),
      );

      expect(find.text('CHAMPIONSHIP TROPHY'), findsOneWidget);
      expect(find.text('AWAITING 2026 CHAMPION'), findsOneWidget);
      expect(find.text('NSMQ CHAMPION'), findsNothing);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('StageBracketCard renders school logo and name without cup/trophy icons', (tester) async {
      const qfContest = StageContestPreview(
        id: 'c_qf_1',
        matchLabel: 'SF MATCH 1',
        title: 'Semi-Final 1',
        status: 'Live',
        schoolNames: ['PRESEC LEGON', 'PREMPEH', 'MFANTSIPIM'],
        scores: [47, 43, 34],
        winner: 'PRESEC LEGON',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StageBracketCard(
              contest: qfContest,
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify match label and live badge
      expect(find.text('SF MATCH 1'), findsOneWidget);
      expect(find.text('LIVE NOW'), findsOneWidget);

      // Verify all 3 schools and scores render
      expect(find.text('PRESEC LEGON'), findsOneWidget);
      expect(find.text('PREMPEH'), findsOneWidget);
      expect(find.text('MFANTSIPIM'), findsOneWidget);
      expect(find.text('47'), findsOneWidget);
      expect(find.text('43'), findsOneWidget);
      expect(find.text('34'), findsOneWidget);

      // Verify cup/trophy icons are completely removed from the card
      expect(find.byIcon(Icons.emoji_events_outlined), findsNothing);
      expect(find.byIcon(Icons.emoji_events), findsNothing);

      // Verify winner is rendered with red text
      final winnerText = tester.widget<Text>(find.text('PRESEC LEGON'));
      expect(winnerText.style?.color, equals(NeoColors.nsmqRed));
    });

    testWidgets('BracketStageGroup renders outgoing 3-to-1 bracket connector lines', (tester) async {
      const qfContests = [
        StageContestPreview(
          id: 'c_qf_1',
          matchLabel: 'QF MATCH 1',
          title: 'Quarter-Final 1',
          status: 'Finished',
          schoolNames: ['PRESEC LEGON', 'ACCRA ACADEMY', 'TAMALE SHS'],
          scores: [70, 39, 29],
          winner: 'PRESEC LEGON',
        ),
        StageContestPreview(
          id: 'c_qf_2',
          matchLabel: 'QF MATCH 2',
          title: 'Quarter-Final 2',
          status: 'Finished',
          schoolNames: ['PREMPEH', 'ADISADEL', 'KUHIS'],
          scores: [63, 42, 28],
          winner: 'PREMPEH',
        ),
        StageContestPreview(
          id: 'c_qf_3',
          matchLabel: 'QF MATCH 3',
          title: 'Quarter-Final 3',
          status: 'Finished',
          schoolNames: ['MFANTSIPIM', 'ST. AUGUSTINE\'S', 'POJOSS'],
          scores: [55, 48, 32],
          winner: 'MFANTSIPIM',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BracketStageGroup(
              contests: qfContests,
              showOutgoingConnectors: true,
              showIncomingConnectors: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(StageBracketCard), findsNWidgets(3));
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('StageBracketCard does not announce a winner or show scores for Upcoming matches', (tester) async {
      const upcomingContest = StageContestPreview(
        id: 'contest_sched_106',
        matchLabel: 'GRAND FINALE MATCH',
        title: 'Grand Championship',
        status: 'Upcoming',
        schoolNames: ['PRESEC LEGON', 'OWASS', 'ACHIMOTA'],
        scores: [0, 0, 0],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StageBracketCard(
              contest: upcomingContest,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('GRAND FINALE MATCH'), findsOneWidget);
      expect(find.text('UPCOMING'), findsOneWidget);

      // Verify all schools display with neutral text (no red text for winner)
      final presecText = tester.widget<Text>(find.text('PRESEC LEGON'));
      final owassText = tester.widget<Text>(find.text('OWASS'));
      final achimotaText = tester.widget<Text>(find.text('ACHIMOTA'));

      expect(presecText.style?.color, equals(NeoColors.textPrimary));
      expect(owassText.style?.color, equals(NeoColors.textPrimary));
      expect(achimotaText.style?.color, equals(NeoColors.textPrimary));

      // Verify unplayed score placeholders '-' are rendered instead of misleading scores
      expect(find.text('-'), findsNWidgets(3));
    });

    testWidgets('Full TournamentView loads with NSMQ TOURNAMENT header, stage swiper, and bottom controls', (tester) async {
      late final List<TournamentStage> stages;
      late final List<TournamentAward> awards;
      await tester.runAsync(() async {
        final realRepo = TournamentRepositoryImpl();
        stages = await realRepo.getStages();
        awards = await realRepo.getAwards();
      });

      final fastRepo = MockTournamentRepository(mockStages: stages, mockAwards: awards);
      Get.put<TournamentController>(TournamentController(repository: fastRepo));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: TournamentView(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Verify wireframe header: NSMQ TOURNAMENT
      expect(find.text('NSMQ TOURNAMENT'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);

      // Verify bottom swipe guidance
      expect(
        find.text('Swipe horizontally to navigate through the tournament stages'),
        findsOneWidget,
      );

      // Verify page view renders
      expect(find.byType(PageView), findsOneWidget);

      // Navigate to Grand Finale tab
      final controller = Get.find<TournamentController>();
      controller.selectStage(4, animate: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Grand Finale stage displays the centered match card and swipe prompt (no inline trophy)
      expect(find.text('GRAND FINALE'), findsWidgets);
      expect(find.text('SWIPE FOR THE TROPHY'), findsOneWidget);
      expect(find.byType(StageBracketCard), findsOneWidget);

      // Navigate / swipe again to The Trophy page (index 5)
      controller.selectStage(5, animate: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Trophy stage displays the Championship Trophy with exact picture and awaiting champion
      expect(find.text('THE TROPHY'), findsWidgets);
      expect(find.text('CHAMPIONSHIP TROPHY'), findsOneWidget);
      expect(find.text('AWAITING 2026 CHAMPION'), findsOneWidget);
      expect(find.text('NSMQ CHAMPION'), findsNothing);
      expect(find.byType(TrophyChampionWidget), findsOneWidget);
    });

    testWidgets('ContestDetailView tab bar renders OVERVIEW, ROUNDS, LINEUPS, H2H without clipping', (tester) async {
      Get.put(ContestDetailController(
        repository: ContestDetailRepositoryImpl(),
      ));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ContestDetailView(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('OVERVIEW'), findsOneWidget);
      expect(find.text('ROUNDS'), findsOneWidget);
      expect(find.text('LINEUPS'), findsOneWidget);
      expect(find.text('H2H'), findsOneWidget);

      // Verify tapping tabs
      await tester.tap(find.text('ROUNDS'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('LINEUPS'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('H2H'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('OVERVIEW'));
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
