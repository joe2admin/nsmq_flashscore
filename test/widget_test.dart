import 'package:flutter_test/flutter_test.dart';
import 'package:nsmq_flashscore/main.dart';

void main() {
  testWidgets('Design system showcase loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NsmqFlashscoreApp());

    // Verify app bar title renders
    expect(find.text('NSMQ FLASHSCORE'), findsOneWidget);
  });
}
