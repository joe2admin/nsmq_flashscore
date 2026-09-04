import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nsmq_flashscore/features/news/presentation/widgets/feed_post_card.dart';
import 'package:nsmq_flashscore/features/live_scores/data/repositories/contest_repository_impl.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/contest.dart';
import 'package:nsmq_flashscore/features/live_scores/domain/entities/round_scores.dart';
import 'package:nsmq_flashscore/app/theme/app_colors.dart';
import 'package:nsmq_flashscore/features/news/data/repositories/news_repository_impl.dart';
import 'package:nsmq_flashscore/features/news/domain/entities/feed_post.dart';
import 'package:nsmq_flashscore/features/schools/data/repositories/schools_repository_impl.dart';
import 'package:nsmq_flashscore/features/tournament/data/repositories/tournament_repository_impl.dart';
import 'package:nsmq_flashscore/core/constants/school_assets.dart';
import 'package:nsmq_flashscore/core/utils/number_formatter.dart';
import 'package:nsmq_flashscore/features/live_scores/data/providers/mock_contest_data.dart';

void main() {
  group('Contest & Scoreboard Logic', () {
    test('RoundScores total computes correctly across all 5 rounds', () {
      const scores = RoundScores(
        r1: 21,
        r2: 18,
        r3: 10,
        r4: 12,
        r5: 9,
      );
      expect(scores.total, equals(70));
    });

    test('ContestRepositoryImpl retrieves contests and applies search filter', () async {
      final repo = ContestRepositoryImpl();
      final all = await repo.getContests();
      expect(all.isNotEmpty, isTrue);

      final presecMatches = await repo.getContests(searchQuery: 'PRESEC');
      expect(presecMatches.isNotEmpty, isTrue);
      for (final match in presecMatches) {
        final hasPresec = match.entries.any((e) =>
            e.school.name.contains('Presbyterian') ||
            e.school.shortName.contains('PRESEC'));
        expect(hasPresec, isTrue);
      }
    });

    test('ContestRepositoryImpl filters by status correctly', () async {
      final repo = ContestRepositoryImpl();
      final liveMatches = await repo.getContests(status: ContestStatus.live);
      for (final match in liveMatches) {
        expect(match.status, equals(ContestStatus.live));
      }
    });
  });

  group('Schools Repository & Favorites', () {
    test('SchoolsRepositoryImpl toggles school favorite state', () async {
      final repo = SchoolsRepositoryImpl();
      final school = await repo.getSchoolById('sch_presec');
      expect(school, isNotNull);
      final initialFav = school!.isFavorite;

      await repo.toggleFavorite('sch_presec');
      final updatedSchool = await repo.getSchoolById('sch_presec');
      expect(updatedSchool!.isFavorite, equals(!initialFav));
    });

    test('SchoolsRepositoryImpl filters by champions only', () async {
      final repo = SchoolsRepositoryImpl();
      final champions = await repo.getSchools(onlyChampions: true);
      for (final s in champions) {
        expect(s.school.titlesCount > 0, isTrue);
      }
    });
  });

  group('Tournament Repository', () {
    test('TournamentRepositoryImpl provides stages with contests and awards', () async {
      final repo = TournamentRepositoryImpl();
      final stages = await repo.getStages();
      final awards = await repo.getAwards();

      expect(stages.isNotEmpty, isTrue);
      expect(awards.isNotEmpty, isTrue);
      expect(awards.first.title.isNotEmpty, isTrue);
    });
  });

  group('Twitter-Style NSMQ Feed & Engagement Logic', () {
    test('NewsRepositoryImpl retrieves feed posts and filters by categories', () async {
      final repo = NewsRepositoryImpl();
      final allPosts = await repo.getFeedPosts(category: 'FOR YOU');
      expect(allPosts.isNotEmpty, isTrue);

      final photoPosts = await repo.getFeedPosts(category: 'PHOTOS');
      expect(photoPosts.isNotEmpty, isTrue);
      for (final post in photoPosts) {
        expect(post.imageUrl, isNotNull);
      }

      final pollPosts = await repo.getFeedPosts(category: 'POLLS');
      expect(pollPosts.isNotEmpty, isTrue);
      for (final post in pollPosts) {
        expect(post.poll, isNotNull);
      }
    });

    test('NewsRepositoryImpl toggles post like and updates count', () async {
      final repo = NewsRepositoryImpl();
      final posts = await repo.getFeedPosts();
      final targetPost = posts.first;
      final initialLikes = targetPost.likesCount;
      final initialLiked = targetPost.isLiked;

      final result1 = await repo.toggleLike(targetPost.id);
      expect(result1, equals(!initialLiked));

      final updatedPosts = await repo.getFeedPosts();
      final updatedPost = updatedPosts.firstWhere((p) => p.id == targetPost.id);
      expect(updatedPost.isLiked, equals(!initialLiked));
      expect(updatedPost.likesCount, equals(initialLikes + 1));

      // Toggle back
      final result2 = await repo.toggleLike(targetPost.id);
      expect(result2, equals(initialLiked));
    });

    test('NewsRepositoryImpl adds comments and increments comment count', () async {
      final repo = NewsRepositoryImpl();
      final posts = await repo.getFeedPosts();
      final targetPost = posts.first;
      final initialCommentsCount = targetPost.commentsCount;

      final comment = await repo.addComment(
        targetPost.id,
        'Presec all the way! 🦁',
        authorName: 'Kwame',
        authorHandle: '@kwame_gh',
      );

      expect(comment.content, equals('Presec all the way! 🦁'));
      expect(comment.authorName, equals('Kwame'));

      final updatedPosts = await repo.getFeedPosts();
      final updatedPost = updatedPosts.firstWhere((p) => p.id == targetPost.id);
      expect(updatedPost.commentsCount, equals(initialCommentsCount + 1));
      expect(updatedPost.comments.first.content, equals('Presec all the way! 🦁'));
    });

    test('NewsRepositoryImpl toggles comment like state and updates count', () async {
      final repo = NewsRepositoryImpl();
      final posts = await repo.getFeedPosts();
      final targetPost = posts.firstWhere((p) => p.comments.isNotEmpty);
      final targetComment = targetPost.comments.first;
      final initialLikes = targetComment.likesCount;
      final initialLiked = targetComment.isLiked;

      final res1 = await repo.toggleCommentLike(targetPost.id, targetComment.id);
      expect(res1, equals(!initialLiked));

      final updatedPosts = await repo.getFeedPosts();
      final updatedComment = updatedPosts
          .firstWhere((p) => p.id == targetPost.id)
          .comments
          .firstWhere((c) => c.id == targetComment.id);
      expect(updatedComment.isLiked, equals(!initialLiked));
      expect(updatedComment.likesCount, equals(initialLikes + 1));

      // Toggle back
      final res2 = await repo.toggleCommentLike(targetPost.id, targetComment.id);
      expect(res2, equals(initialLiked));
    });

    test('NewsRepositoryImpl adds reply to a comment with replyingToHandle', () async {
      final repo = NewsRepositoryImpl();
      final posts = await repo.getFeedPosts();
      final targetPost = posts.first;

      final reply = await repo.addComment(
        targetPost.id,
        'I agree with this completely! 👏',
        authorName: 'Ebenezer',
        authorHandle: '@ebenezer_gh',
        replyingToHandle: '@kofi_mensah',
      );

      expect(reply.replyingToHandle, equals('@kofi_mensah'));
      expect(reply.content, equals('I agree with this completely! 👏'));

      final updatedPosts = await repo.getFeedPosts();
      final updatedPost = updatedPosts.firstWhere((p) => p.id == targetPost.id);
      expect(updatedPost.comments.first.replyingToHandle, equals('@kofi_mensah'));
    });

    test('NewsRepositoryImpl allows voting in interactive feed poll', () async {
      final repo = NewsRepositoryImpl();
      final pollPosts = await repo.getFeedPosts(category: 'POLLS');
      final targetPost = pollPosts.first;
      final initialTotalVotes = targetPost.poll!.totalVotes;
      final initialOptionVotes = targetPost.poll!.options[1].votes;

      final updatedPost = await repo.votePoll(targetPost.id, 1);
      expect(updatedPost.poll!.userVotedIndex, equals(1));
      expect(updatedPost.poll!.totalVotes, equals(initialTotalVotes + 1));
      expect(updatedPost.poll!.options[1].votes, equals(initialOptionVotes + 1));
    });

    test('NewsRepositoryImpl creates and prepends a new feed dispatch', () async {
      final repo = NewsRepositoryImpl();
      final initialPosts = await repo.getFeedPosts();
      final initialCount = initialPosts.length;

      const newPost = FeedPost(
        id: 'post_custom_1',
        authorName: 'Amanfoo Supporter',
        authorHandle: '@amanfoo_fan',
        authorInitials: 'AF',
        authorColor: NeoColors.green,
        content: 'Buzzer practice is looking sharp for tomorrow! 🟢⚡ #Prempeh',
        timeAgo: 'Just now',
      );

      await repo.createPost(newPost);
      final refreshedPosts = await repo.getFeedPosts();
      expect(refreshedPosts.length, equals(initialCount + 1));
      expect(refreshedPosts.first.id, equals('post_custom_1'));
      expect(refreshedPosts.first.authorHandle, equals('@amanfoo_fan'));
    });
  });

  group('NSMQ Branding & School Badges', () {
    test('SchoolAssets defines valid NSMQ logo and school crest paths', () {
      expect(SchoolAssets.nsmqLogo, equals('assets/images/nsmq_logo.png'));
      expect(SchoolAssets.getBadge('PRESEC LEGON'), equals(SchoolAssets.presec));
      expect(SchoolAssets.getBadge('PREMPEH'), equals(SchoolAssets.prempeh));
      expect(SchoolAssets.getBadge('MFANTSIPIM'), equals(SchoolAssets.mfantsipim));
      expect(SchoolAssets.getBadge('OWASS'), equals(SchoolAssets.opokuWare));
      expect(SchoolAssets.getBadge('ACHIMOTA'), equals(SchoolAssets.achimota));
      expect(SchoolAssets.getBadge('ST. PETER\'S (PERSCO)'), equals(SchoolAssets.stPeters));
      expect(SchoolAssets.getBadge('KETA SHTS (DZOLALI)'), equals(SchoolAssets.keta));
      expect(SchoolAssets.getBadge('WEY GEY HEY'), equals(SchoolAssets.wesleyGirls));
      expect(SchoolAssets.getBadge('AUGUSCO'), equals(SchoolAssets.stAugustines));
      expect(SchoolAssets.getBadge('ADISCO (ZEBRA)'), equals(SchoolAssets.adisadel));
      expect(SchoolAssets.getBadge('TAMASCO'), equals(SchoolAssets.tamale));
      expect(SchoolAssets.getBadge('KUHIS'), equals(SchoolAssets.kumasiHigh));
      expect(SchoolAssets.getBadge('ACCRA ACADEMY'), equals(SchoolAssets.accraAcademy));
      expect(SchoolAssets.getBadge('POJOSS'), equals(SchoolAssets.popeJohn));
      expect(SchoolAssets.getBadge('KUMASI ACADEMY'), equals(SchoolAssets.kumasiAcademy));
    });

    test('All reference schools in MockContestData have non-null crestUrl', () {
      final contests = MockContestData.getContests();
      for (final contest in contests) {
        for (final entry in contest.entries) {
          expect(entry.school.crestUrl, isNotNull);
          expect(entry.school.crestUrl!.isNotEmpty, isTrue);
        }
      }
    });

    test('SchoolsRepositoryImpl profiles have non-null crestUrl for all schools', () async {
      final repo = SchoolsRepositoryImpl();
      final schools = await repo.getSchools();
      expect(schools.length, greaterThanOrEqualTo(10));
      for (final profile in schools) {
        expect(profile.school.crestUrl, isNotNull);
        expect(profile.school.crestUrl!.startsWith('assets/images/schools/'), isTrue);
      }
    });
  });

  group('NumberFormatter Logic', () {
    test('NumberFormatter shortens to K and M only at 10,000 and above', () {
      expect(NumberFormatter.formatCount(0), equals('0'));
      expect(NumberFormatter.formatCount(45), equals('45'));
      expect(NumberFormatter.formatCount(890), equals('890'));
      expect(NumberFormatter.formatCount(1000), equals('1,000'));
      expect(NumberFormatter.formatCount(1420), equals('1,420'));
      expect(NumberFormatter.formatCount(3120), equals('3,120'));
      expect(NumberFormatter.formatCount(9999), equals('9,999'));
      expect(NumberFormatter.formatCount(10000), equals('10K'));
      expect(NumberFormatter.formatCount(10500), equals('10.5K'));
      expect(NumberFormatter.formatCount(24000), equals('24K'));
      expect(NumberFormatter.formatCount(99900), equals('99.9K'));
      expect(NumberFormatter.formatCount(100000), equals('100K'));
      expect(NumberFormatter.formatCount(500000), equals('500K'));
      expect(NumberFormatter.formatCount(1000000), equals('1M'));
      expect(NumberFormatter.formatCount(1200000), equals('1.2M'));
      expect(NumberFormatter.formatCount(15500000), equals('15.5M'));
    });
  });

  group('FeedPostCard Text & Whitespace Preservation', () {
    testWidgets('FeedPostCard preserves spaces, newlines, and highlights hashtags and mentions', (WidgetTester tester) async {
      const content = 'Hello world! 🦁\n\nWe are here with @PresecLegon to celebrate #NSMQ2024 victory.';
      const post = FeedPost(
        id: 'test_post',
        authorName: 'Tester',
        authorHandle: '@tester',
        authorInitials: 'TT',
        authorColor: NeoColors.green,
        content: content,
        timeAgo: '1m',
        likesCount: 10,
        commentsCount: 2,
        sharesCount: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: FeedPostCard(
                post: post,
                onLikeTap: () {},
                onCommentTap: () {},
                onShareTap: () {},
                onBookmarkTap: () {},
              ),
            ),
          ),
        ),
      );

      final richTextFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.textSpan != null,
      );
      expect(richTextFinder, findsOneWidget);
      final textWidget = tester.widget<Text>(richTextFinder);
      final fullRenderedText = textWidget.textSpan!.toPlainText();
      expect(fullRenderedText, equals(content));
    });
  });
}


