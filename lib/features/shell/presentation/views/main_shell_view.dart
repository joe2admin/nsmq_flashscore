import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsmq_flashscore/features/favorites/presentation/views/favorites_view.dart';
import 'package:nsmq_flashscore/features/live_scores/presentation/views/live_scores_view.dart';
import 'package:nsmq_flashscore/features/news/presentation/views/news_feed_view.dart';
import 'package:nsmq_flashscore/features/schools/presentation/views/schools_directory_view.dart';
import 'package:nsmq_flashscore/features/tournament/presentation/views/tournament_view.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/neo_bottom_nav_bar.dart';

class MainShellView extends GetView<NavigationController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    const pages = [
      LiveScoresView(),
      TournamentView(),
      SchoolsDirectoryView(),
      NewsFeedView(),
      FavoritesView(),
    ];

    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: NeoBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
        ),
      );
    });
  }
}
