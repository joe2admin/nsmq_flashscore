import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nsmq_flashscore/app/theme/app_typography.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Strictly enforce offline font resolution
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Bundled Google Fonts Asset Tests', () {
    test('License file OFL.txt is accessible in assets', () async {
      final license = await rootBundle.loadString('google_fonts/OFL.txt');
      expect(license, isNotEmpty);
      expect(license, contains('SIL OPEN FONT LICENSE'));
    });

    test('All required font files exist and are loadable from rootBundle', () async {
      final fontFiles = [
        'google_fonts/ArchivoBlack-Regular.ttf',
        'google_fonts/IBMPlexSans-Regular.ttf',
        'google_fonts/IBMPlexSans-Italic.ttf',
        'google_fonts/IBMPlexSans-Medium.ttf',
        'google_fonts/IBMPlexSans-MediumItalic.ttf',
        'google_fonts/IBMPlexSans-SemiBold.ttf',
        'google_fonts/IBMPlexSans-SemiBoldItalic.ttf',
        'google_fonts/IBMPlexSans-Bold.ttf',
        'google_fonts/IBMPlexSans-BoldItalic.ttf',
        'google_fonts/IBMPlexSans-Light.ttf',
        'google_fonts/IBMPlexSans-LightItalic.ttf',
        'google_fonts/IBMPlexSans-ExtraLight.ttf',
        'google_fonts/IBMPlexSans-ExtraLightItalic.ttf',
        'google_fonts/IBMPlexSans-Thin.ttf',
        'google_fonts/IBMPlexSans-ThinItalic.ttf',
      ];

      for (final fontPath in fontFiles) {
        final byteData = await rootBundle.load(fontPath);
        expect(byteData.lengthInBytes, greaterThan(0), reason: '$fontPath should not be empty');
      }
    });

    testWidgets('Renders NeoTypography text styles with allowRuntimeFetching = false without exception', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Display Large', style: NeoTypography.displayLarge()),
                Text('Display Medium', style: NeoTypography.displayMedium()),
                Text('Heading Large', style: NeoTypography.headingLarge()),
                Text('Heading Medium', style: NeoTypography.headingMedium()),
                Text('Score Text', style: NeoTypography.scoreText()),
                Text('Badge', style: NeoTypography.badge()),
                Text('Body Bold', style: NeoTypography.bodyBold()),
                Text('Body Medium', style: NeoTypography.bodyMedium()),
                Text('Body Regular', style: NeoTypography.bodyRegular()),
                Text('Caption', style: NeoTypography.caption()),
                Text(
                  'Italic Motto',
                  style: NeoTypography.bodyMedium().copyWith(fontStyle: FontStyle.italic),
                ),
                Text(
                  'SemiBold Text',
                  style: NeoTypography.caption().copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      );

      // Wait for GoogleFonts pending futures to resolve from rootBundle
      await tester.pumpAndSettle();

      expect(find.text('Display Large'), findsOneWidget);
      expect(find.text('Heading Large'), findsOneWidget);
      expect(find.text('Body Bold'), findsOneWidget);
      expect(find.text('Body Regular'), findsOneWidget);
      expect(find.text('Italic Motto'), findsOneWidget);
    });
  });
}
