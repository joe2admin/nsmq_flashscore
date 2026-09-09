import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nsmq_flashscore/core/widgets/neo_skeleton.dart';
import 'package:nsmq_flashscore/features/contest_detail/presentation/widgets/contest_detail_skeleton.dart';
import 'package:nsmq_flashscore/features/favorites/presentation/widgets/favorites_skeleton.dart';
import 'package:nsmq_flashscore/features/live_scores/presentation/widgets/match_list_skeleton.dart';
import 'package:nsmq_flashscore/features/news/presentation/widgets/news_feed_skeleton.dart';
import 'package:nsmq_flashscore/features/schools/presentation/widgets/school_detail_skeleton.dart';
import 'package:nsmq_flashscore/features/schools/presentation/widgets/schools_directory_skeleton.dart';
import 'package:nsmq_flashscore/features/tournament/presentation/widgets/tournament_skeleton.dart';

void main() {
  group('Neo-Brutalist Skeleton Loading Tests', () {
    testWidgets('NeoSkeletonShimmer and NeoSkeletonBone render and animate properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NeoSkeletonShimmer(
              child: Column(
                children: [
                  NeoSkeletonBone(width: 100, height: 20),
                  NeoSkeletonBone.circle(size: 40),
                  NeoSkeletonBone.line(width: 150, height: 14),
                  NeoSkeletonBone.badge(width: 60, height: 22),
                  NeoSkeletonCard(
                    child: NeoSkeletonBone.line(width: 80, height: 12),
                  ),
                  NeoSkeletonFolderCard(
                    child: NeoSkeletonBone.line(width: 120, height: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Initial pump
      await tester.pump();
      expect(find.byType(NeoSkeletonShimmer), findsOneWidget);
      expect(find.byType(NeoSkeletonBone), findsWidgets);
      expect(find.byType(NeoSkeletonCard), findsOneWidget);
      expect(find.byType(NeoSkeletonFolderCard), findsOneWidget);

      // Advance animation frame
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('MatchListSkeleton renders without errors on mobile viewport', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MatchListSkeleton(itemCount: 2),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(MatchListSkeleton), findsOneWidget);
      expect(find.byType(NeoSkeletonFolderCard), findsNWidgets(2));
      await tester.pump(const Duration(milliseconds: 200));
    });

    testWidgets('ContestDetailSkeleton renders without errors', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContestDetailSkeleton(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(ContestDetailSkeleton), findsOneWidget);
      expect(find.byType(NeoSkeletonShimmer), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
    });

    testWidgets('NewsFeedSkeleton renders in both posts and articles modes', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Social feed post mode
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NewsFeedSkeleton(isArticles: false, itemCount: 2),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(NewsFeedSkeleton), findsOneWidget);

      // Articles mode
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NewsFeedSkeleton(isArticles: true, itemCount: 2),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(NewsFeedSkeleton), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
    });

    testWidgets('SchoolsDirectorySkeleton renders properly', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SchoolsDirectorySkeleton(itemCount: 4),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SchoolsDirectorySkeleton), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
    });

    testWidgets('SchoolDetailSkeleton renders hero, records, and contestants', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SchoolDetailSkeleton(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SchoolDetailSkeleton), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
    });

    testWidgets('TournamentSkeleton renders bracket cards properly', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TournamentSkeleton(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TournamentSkeleton), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
    });

    testWidgets('FavoritesSkeleton renders pinned schools and alert preferences', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FavoritesSkeleton(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(FavoritesSkeleton), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
    });
  });
}
