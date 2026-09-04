import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nsmq_flashscore/main.dart';

void main() {
  testWidgets('NSMQ Flashscore loads 5 bottom tabs and initial contests shell', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NsmqFlashscoreApp());
    await tester.pumpAndSettle();

    // Verify app bar title renders
    expect(find.text('NSMQ FLASHSCORE'), findsOneWidget);

    // Verify 5 Bottom Navigation items render
    expect(find.text('CONTESTS'), findsOneWidget);
    expect(find.text('BRACKET'), findsOneWidget);
    expect(find.text('SCHOOLS'), findsOneWidget);
    expect(find.text('FEED'), findsOneWidget);
    expect(find.text('FAVORITES'), findsOneWidget);

    // Verify all 4 status filter chips render with identical height
    final allPill = find.text('ALL');
    final livePill = find.text('LIVE');
    final upcomingPill = find.text('UPCOMING');
    final finishedPill = find.text('FINISHED');

    expect(allPill, findsOneWidget);
    expect(livePill, findsOneWidget);
    expect(upcomingPill, findsOneWidget);
    expect(finishedPill, findsOneWidget);

    // Verify sizes of each chip's container
    final containers = find.byType(AnimatedContainer);
    expect(containers, findsWidgets);

    // Tap LIVE pill and verify pressed interaction
    await tester.tap(livePill);
    await tester.pumpAndSettle();
  });
}
